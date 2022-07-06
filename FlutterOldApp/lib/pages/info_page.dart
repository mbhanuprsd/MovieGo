import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_go/constants.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  final String userName;
  InfoPage(this.userName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Developer"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mail),
            onPressed: () {
              launch(
                  "mailto:${AppConstants.mailAddress}?subject=MovieGo - $userName"
                  "&body=");
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: new AssetImage("assets/images/poster.jpg"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Color.fromARGB(200, 0, 0, 0)),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: AppConstants.infoImage,
                        placeholder: new CircularProgressIndicator(),
                        errorWidget: new Icon(Icons.person),
                        height: 100.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CustomText("Bhanu Prasad Merakanapalli", 20.0, true,
                                Colors.white, 2),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                            ),
                            CustomText("Job: Android/Unity3D Developer", 16.0,
                                false, Colors.white, null),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  CustomText(
                      "Experince: 5 years", 16.0, false, Colors.white, null),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  CustomText(
                      "Skills: Java, Android, C#, Unity3D, "
                      "Xamarin-Android, Flutter, Dart",
                      16.0,
                      false,
                      Colors.white,
                      null),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  CustomText("Place: Hyderabad, India", 16.0, false,
                      Colors.white, null),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  CustomText(
                      "App Info:"
                      "\n\n- APIs used in the app are from themoviedb.org"
                      "\n- For bookmarking, used Firestore"
                      "\n- For login/SignUp, used Firebase "
                      "Authentication",
                      14.0,
                      false,
                      Colors.white,
                      null),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
