import 'package:flutter/material.dart';
import 'package:movie_go/utils/navigator_util.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          'MovieGo!',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => MyNavigator.goToSearch(context),
          ),
        ],
      ),
      body: new Container(),
    );
  }
}
