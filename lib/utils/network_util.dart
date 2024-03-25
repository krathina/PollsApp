import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkUtil {
  // next three lines makes this class a Singleton
  static final NetworkUtil _instance = NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = const JsonDecoder();

  Future<dynamic> get(String url, {required Map headers, body, encoding}) {
    return http.get(url as Uri, headers: {}).then((http.Response response) {
      final String res = response.body;

      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<Map> post(String url, {required Map headers, body, encoding}) async {
    try {
      http.Response response = await http.post(Uri.parse(url),
          body: body,
          headers: {
            'Accept': 'application/json',
          },
          encoding: encoding);
      print(response.body);

      Map res = json.decode(response.body);

      int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }
      return res;
    } catch (e) {
      throw Exception("Error while fetching data$e");
    }
  }
}
