import 'package:flash_chat/ViewModel_AuthProvider.dart';
import 'package:flash_chat/UserProvider.dart';
import 'package:flash_chat/user.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();

  String _username, _password;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final usernameField = TextFormField(
      autofocus: false,
      validator: validateEmail,
      onSaved: (value) => _username = value,
      decoration: buildInputDecoration("Confirm password", Icons.email),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(0.0),
          child: Text("Forgot password?",
              style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
//            Navigator.pushReplacementNamed(context, '/reset-password');
          },
        ),
        FlatButton(
          padding: EdgeInsets.only(left: 0.0),
          child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/register');
          },
        ),
      ],
    );

    var doLogin = () {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();

        final Future<Map<String, dynamic>> successfulMessage =
        auth.login(_username, _password);

        successfulMessage.then((response) {
          if (response['status']) {
            User user = response['user'];
            print(user.email);
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            Flushbar(
              //['message'].toString()
              title: "Failed Login",
              message: response['message'],
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        print("form is invalid");
      }
    };

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(40.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 250.0),
                  label("Email"),
                  SizedBox(height: 5.0),
                  usernameField,
                  SizedBox(height: 20.0),
                  label("Password"),
                  SizedBox(height: 5.0),
                  passwordField,
                  SizedBox(height: 20.0),
                  auth.loggedInStatus == Status.Authenticating
                      ? loading
                      : longButtons("Login", doLogin),
                  SizedBox(height: 5.0),
                  forgotLabel
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
MaterialButton longButtons(String title, Function fun,
    {Color color: const Color(0xfff063057), Color textColor: Colors.white}) {
  return MaterialButton(
    onPressed: fun,
    textColor: textColor,
    color: color,
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    ),
    height: 45,
    minWidth: 600,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
  );
}

label(String title) => Text(title);

InputDecoration buildInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: Color.fromRGBO(50, 62, 72, 1.0)),
    // hintText: hintText,
    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );
}
String validateEmail(String value) {
  String _msg;
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value.isEmpty) {
    _msg = "Your username is required";
  } else if (!regex.hasMatch(value)) {
    _msg = "Please provide a valid emal address";
  }
  return _msg;
}