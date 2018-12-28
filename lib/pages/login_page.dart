import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:movie_go/utils/app_util.dart';
import 'package:movie_go/utils/navigator_util.dart';
import 'dart:core';

FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Center(
          child: new Text(
            'Login',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: new Container(
          padding: EdgeInsets.all(20.0),
          alignment: FractionalOffset.center,
          child: new Form(
            key: formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new TextFormField(
                  decoration: new InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value.isEmpty ? 'Please enter email' : null,
                  onSaved: (value) => _email = value,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                new TextFormField(
                  decoration: new InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                      value.isEmpty ? 'Please enter password' : null,
                  onSaved: (value) => _password = value,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                new RaisedButton(
                  child: new Text(
                    'Login',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () => validateAndSave()
                      .then((user) => MyNavigator.goToHome(context))
                      .catchError((e) =>
                          AppUtils.showSimpleAlert(context, e.toString())),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                CenterText("New user?", 20.0, true, Colors.white, 2),
                new RaisedButton(
                  child: new Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () => MyNavigator.goToSignUp(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> validateAndSave() async {
    final loginForm = formKey.currentState;
    loginForm.save();
    if (loginForm.validate()) {
      print('Valid Form. Email: $_email, Password: $_password');
      FirebaseUser user = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      return user;
    } else {
      throw new Exception("Inavlid form");
    }
  }
}
