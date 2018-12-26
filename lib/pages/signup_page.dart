import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:movie_go/utils/app_util.dart';
import 'package:movie_go/utils/navigator_util.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = new GlobalKey<FormState>();

  String _fullName;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Center(
          child: new Text(
            'Sign Up',
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
                  decoration: new InputDecoration(labelText: 'Full Name'),
                  validator: (value) =>
                      value.isEmpty ? 'Please enter full name' : null,
                  onSaved: (value) => _fullName = value,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
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
                new TextFormField(
                  decoration: new InputDecoration(labelText: 'Retype Password'),
                  obscureText: true,
                  validator: (value) => (value.isEmpty && _password != value)
                      ? 'Please retype password'
                      : null,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                new RaisedButton(
                  child: new Text(
                    'Create Account',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () => validateAndSave().then((user) {
                        AppUtils.showAlert(context, "Registered Succesfully!",
                            null, "Ok", () => MyNavigator.goToHome(context));
                      }).catchError((e) => print(e)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                CenterText("Already a user?", 20.0, true, Colors.white, 2),
                new RaisedButton(
                  child: new Text(
                    'Login',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () => MyNavigator.goToLogin(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> validateAndSave() async {
    final signUpForm = formKey.currentState;
    signUpForm.save();
    if (signUpForm.validate()) {
      print('Valid Form. Email: $_email, Password: $_password');
      FirebaseUser user = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = _fullName;
      await user.updateProfile(userUpdateInfo);
      user.sendEmailVerification();
      return user;
    } else {
      throw new Exception("Inavlid form");
    }
  }
}
