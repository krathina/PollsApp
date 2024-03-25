import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:polls_app/auth.dart';
import 'package:polls_app/data/database_helper.dart';
import 'package:polls_app/models/user.dart';
import 'package:polls_app/data/rest_ds.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  late BuildContext _ctx;

  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late String _username, _password;
  RestDatasource api = RestDatasource();

  LoginScreenState() {
    checkLoggedIn();
  }

  checkLoggedIn() async {
    String currState = await getAuthState();
    if (currState != "logged_out") {
      Navigator.of(_ctx).pushReplacementNamed("/home");
    }
  }

  void _submit() {
    final form = formKey.currentState;

    if (form!.validate()) {
      setState(() => _isLoading = true);
      form.save();
      doLogin(_username, _password);
    }
  }

  doLogin(String username, String password) async {
    try {
      User user = await api.login(username, password);
      onLoginSuccess(user);
    } catch (error) {
      onLoginError(error.toString());
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
    var loginBtn = ElevatedButton(
      onPressed: _submit,
      //style: Colors.primaries[0],
      child: const Text("LOGIN"),
    );

    var loginForm = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Login App",
          textScaler: TextScaler.linear(2.0),
        ),
        Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (val) => _username = val!,
                  validator: (val) {
                    return val!.length < 10
                        ? "Username must have atleast 10 chars"
                        : null;
                  },
                  decoration: const InputDecoration(labelText: "Username"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (val) => _password = val!,
                  decoration: const InputDecoration(labelText: "Password"),
                ),
              ),
            ],
          ),
        ),
        _isLoading ? const CircularProgressIndicator() : const TextField(),
        Row(
          children: <Widget>[
            loginBtn,
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(_ctx).pushReplacementNamed("/register"),
              child: const Text("Register"),
            ),
          ],
        )
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
                height: 300.0,
                width: 300.0,
                decoration:
                    BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
                child: loginForm,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onLoginError(String errorTxt) {
    _showSnackBar('Login Error: $errorTxt');
    setState(() => _isLoading = false);
  }

  void onLoginSuccess(User user) async {
    _showSnackBar("Login Success");
    setState(() => _isLoading = false);
    var db = DatabaseHelper();
    await db.saveUser(user);
    checkLoggedIn();
  }
}
