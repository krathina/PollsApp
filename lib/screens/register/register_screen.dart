import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:polls_app/data/rest_ds.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  late BuildContext _ctx;

  bool _sendOTPSuccess = false;
  bool _verifyOTPSuccess = false;
  bool _registerSuccess = false;
  bool _isLoading = false;
  final mobileNoFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late String _mobileNo, _otp, _email, _password, _retypePassword;
  RestDatasource api = RestDatasource();

  void _mobileNoSubmit() {
    final form = mobileNoFormKey.currentState;

    if (form!.validate()) {
      setState(() {
        _isLoading = true;
      });
      form.save();
      sendOTP(_mobileNo);
    }
  }

  void _otpSubmit() {
    final form = otpFormKey.currentState;

    if (form!.validate()) {
      setState(() {
        _isLoading = true;
      });
      form.save();
      verifyOTP(_mobileNo, _otp);
    }
  }

  void _registerSubmit() {
    final form = registerFormKey.currentState;

    if (form!.validate()) {
      setState(() {
        _isLoading = true;
      });
      form.save();
      register(_mobileNo, _email, _password, _retypePassword);
    }
  }

  register(String mobileNo, String email, String password,
      String retypePassword) async {
    try {
      await api.register(mobileNo, email, password, retypePassword);
      onRegisterSuccess();
    } catch (error) {
      onRegisterError(error.toString());
    }
  }

  sendOTP(String mobileNo) async {
    try {
      await api.sendOTP(mobileNo);
      onSendOTPSuccess();
    } catch (error) {
      onSendOTPError(error.toString());
    }
  }

  verifyOTP(String mobileNo, String otp) async {
    try {
      await api.verifyOTP(mobileNo, otp);
      onVerifyOTPSuccess();
    } catch (error) {
      onVerifyOTPError(error.toString());
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    var registrationForms = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Login App",
          textScaler: TextScaler.linear(2.0),
        ),
        Column(
          children: buildForms(),
        ),
        _isLoading ? const CircularProgressIndicator() : const TextField(),
        Row(children: buildButtons())
      ],
    );

    return Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/diamond.png"), fit: BoxFit.cover),
        ),
        child: Center(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: 300.0,
                decoration:
                    BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
                child: registrationForms,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildForms() {
    List<Widget> builder = [];
    if (_sendOTPSuccess == false) {
      builder.add(
        Form(
          key: mobileNoFormKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (val) => _mobileNo = val!,
                  validator: (val) {
                    return val!.length < 7
                        ? "Mobile No. must have atleast 10 chars"
                        : null;
                  },
                  decoration: const InputDecoration(labelText: "Mobile No."),
                ),
              )
            ],
          ),
        ),
      );
    } else if (_sendOTPSuccess == true && _verifyOTPSuccess == false) {
      builder.add(
        Form(
          key: otpFormKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (val) => _otp = val!,
                  decoration: const InputDecoration(labelText: "OTP"),
                ),
              ),
            ],
          ),
        ),
      );
    } else {}

    return builder;
  }

  List<Widget> buildButtons() {
    List<Widget> builder = [];
    if (_sendOTPSuccess == false) {
      builder.add(ElevatedButton(
        onPressed: () => _mobileNoSubmit(),
        child: const Text("Next"),
      ));
    } else if (_sendOTPSuccess == true && _verifyOTPSuccess == false) {
      builder.add(ElevatedButton(
        onPressed: () => _otpSubmit(),
        child: const Text("Verify OTP"),
      ));
    } else {
      builder.add(ElevatedButton(
        onPressed: () => _registerSubmit(),
        child: const Text("Register"),
      ));
    }
    return builder;
  }

  void onSendOTPError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() {
      _sendOTPSuccess = false;
      _isLoading = false;
    });
  }

  void onSendOTPSuccess() async {
    _showSnackBar("Please Enter the OTP received");
    setState(() {
      _sendOTPSuccess = true;
      _isLoading = false;
    });
  }

  void onVerifyOTPError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() {
      _verifyOTPSuccess = false;
      _isLoading = false;
    });
  }

  void onVerifyOTPSuccess() async {
    _showSnackBar("OTP Verified");
    setState(() {
      _verifyOTPSuccess = true;
      _isLoading = false;
    });
  }

  void onRegisterError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() {
      _registerSuccess = false;
      _isLoading = false;
    });
  }

  void onRegisterSuccess() async {
    _showSnackBar("Registration Successful");
    setState(() {
      _registerSuccess = true;
      _isLoading = false;
      Navigator.of(_ctx).pushReplacementNamed("/login");
    });
  }
}
