import 'dart:async';
import 'dart:convert';
import 'package:polls_app/models/user.dart';
import 'package:polls_app/utils/network_util.dart';

class RestDatasource {
  final NetworkUtil _netUtil = NetworkUtil();
  static const baseURL = "";
  static const loginURL = "$baseURL/oauth/token";
  static const sendOTPURL = "$baseURL/api/send_otp";
  static const verifyOTPURL = "$baseURL/api/otp_verify";
  static const registerURL = "$baseURL/api/register";
  static const getPollsURL = "$baseURL/api/polls";
  static const voteURL = "$baseURL/api/vote";

  Future<List> getPolls() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    String url = getPollsURL;
    Map res = await _netUtil.get(url, headers: headers);
    if (res.containsKey("error")) throw Exception(res["error"]);
    return res['results'];
  }

  Future<String> vote(String accessToken, int pollId, int answerId) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    String url = '$voteURL/$pollId/$answerId';
    Map res = await _netUtil.get(url, headers: headers);

    if (res.containsKey("error")) throw Exception(res["error"]);

    return res["transactionStatus"];
  }

  Future<User> login(String username, String password) async {
    Map res = await _netUtil.post(loginURL, body: {
      'grant_type': 'password',
      'client_id': '',
      'client_secret': '',
      "username": username,
      "password": password
    }, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    if (res.containsKey("error")) throw Exception(res["error_msg"]);

    return User.map({
      "expires_in": res["expires_in"],
      "access_token": res["access_token"],
      "refresh_token": res["refresh_token"]
    });
  }

  Future<String> sendOTP(String mobileNo) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    Map res = await _netUtil.post(sendOTPURL,
        headers: headers,
        body: json.encode({
          "mobile_no": mobileNo.toString(),
        }));

    if (res.containsKey("error")) throw Exception(res["error"]);

    return res["transactionStatus"];
  }

  Future<String> verifyOTP(String mobileNo, String otp) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    Map res = await _netUtil.post(verifyOTPURL,
        headers: headers,
        body: json.encode({
          "mobile_no": Uri.parse(mobileNo),
          "otp": Uri.parse(otp),
        }));

    if (res.containsKey("error")) throw Exception(res["error"]);

    return res["transactionStatus"];
  }

  Future<String> register(String mobileNo, String email, String password,
      String retypePassword) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    Map res = await _netUtil.post(registerURL,
        headers: headers,
        body: json.encode({
          "mobile_no": Uri.parse(mobileNo),
          "email": Uri.parse(email),
          "password": Uri.parse(password),
          "retype_password": Uri.parse(retypePassword),
        }));

    if (res.containsKey("error")) throw Exception(res["Message"]);
    print("does not contain error");
    return res["transactionStatus"];
  }
}
