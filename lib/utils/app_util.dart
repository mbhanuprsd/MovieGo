import 'dart:io';

import 'package:flutter/material.dart';

class AppUtils {
  static Future<bool> isNetworkConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
    } on SocketException catch (_) {
      return false;
    }
  }

  static showSimpleAlert(BuildContext context, String message) {
    showAlert(context, message, null, "Ok", () => Navigator.of(context).pop());
  }

  static showAlert(BuildContext context, String title, String message,
      String buttonText, Function callBack) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(title),
            content: message == null ? null : new Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text(buttonText),
                onPressed: callBack,
              ),
            ],
          );
        });
  }

  static showContionalAlert(
      BuildContext context,
      String title,
      String message,
      String buttonText1,
      Function callBack1,
      String buttonText2,
      Function callBack2) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(title),
            content: message == null ? null : new Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text(buttonText1),
                onPressed: callBack1,
              ),
              new FlatButton(
                child: new Text(buttonText2),
                onPressed: callBack2,
              ),
            ],
          );
        });
  }
}
