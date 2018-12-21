import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:movie_go/firestore/firestore_manager.dart';
import 'package:movie_go/listitems/movie_item.dart';
import 'package:movie_go/models/custom_models.dart';
import 'package:movie_go/models/movie_details.dart';
import 'package:movie_go/tmdb.dart';
import 'package:movie_go/utils/app_util.dart';
import 'package:movie_go/utils/navigator_util.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  FirebaseUser curentUser;
  List<MovieDetails> favMovieList;

  @override
  void initState() {
    super.initState();
    _auth.currentUser().then((user) {
      curentUser = user;
      fetchBookmarks();
      setState(() {});
    });
  }

  final drawerItems = [
    new DrawerItem("Search", Icons.search),
    new DrawerItem("Settings", Icons.settings),
    new DrawerItem("Logout", Icons.exit_to_app)
  ];

  _onSelectItem(BuildContext bldContext, int index) {
    print(index);
    switch (index) {
      case 0:
        MyNavigator.goToSearch(context);
        break;
      case 1:
        AppUtils.showAlert(context, "Settings", null, "Ok", () {});
        break;
      case 2:
        _auth.signOut().then((_) {
          AppUtils.showContionalAlert(
              context, "Do you want to logout?", null, "Yes", () {
            MyNavigator.goToLogin(context);
          }, "No", () => Navigator.of(context).pop());
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = List();
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(
          d.icon,
          color: Theme.of(context).accentColor,
        ),
        title: new Text(
          d.title,
          style: new TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).accentColor),
        ),
        selected: i == _selectedIndex,
        onTap: () {
          _onSelectItem(context, i);
        },
      ));
    }

    return new Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'MovieGo!',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: CustomText(curentUser?.displayName ?? "", 18.0, true,
                  Theme.of(context).primaryColor, 2),
              accountEmail: CustomText(curentUser?.email ?? "", 18.0, true,
                  Theme.of(context).primaryColor, 2),
              currentAccountPicture: IconButton(
                icon: Icon(
                  Icons.account_circle,
                  size: 60.0,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: null,
              ),
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
              margin: EdgeInsets.all(0.0),
            ),
            Expanded(
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: new Column(
                  children: drawerOptions,
                ),
              ),
            ),
          ],
        ),
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
            child: new Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: CenterText(
                        "Welcome ${curentUser == null ? "" : curentUser.displayName}!",
                        16.0,
                        true,
                        Colors.white,
                        2),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                  ),
                  CustomText("Favorites:", 20.0, true, Colors.white, 1),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  Container(
                    height: 200.0,
                    child: (favMovieList == null || favMovieList?.length == 0)
                        ? favMovieList == null
                            ? Center(child: CustomProgress(context))
                            : Center(
                                child: CenterText("No Favourites", 20.0, true,
                                    Theme.of(context).primaryColor, 1))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: favMovieList.length,
                            itemBuilder: (ctxt, index) {
                              return new FavItem(favMovieList[index]);
                            }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  fetchBookmarks() {
    Firestore.instance.collection(curentUser.uid)?.snapshots()?.listen((qs) {
      favMovieList = new List();
      if (qs != null && qs.documents != null && qs.documents.length > 0) {
        DocumentSnapshot docSnap = qs.documents.firstWhere(
            (doc) => doc.data.containsKey(FireStoreManager.FS_DOC_BOOKMARK));
        if (docSnap != null) {
          String bookMarksString =
              docSnap.data[FireStoreManager.FS_DOC_BOOKMARK].toString();
          if (bookMarksString.length > 0) {
            List<String> strings = bookMarksString.split(',').toList();
            if (strings != null && strings.length > 0) {
              List<int> bookMarks = strings.map((id) => int.parse(id)).toList();
              for (var id in bookMarks) {
                fetchMovieDetails(id);
              }
              return;
            }
          }
        }
      }
      setState(() {});
    });
  }

  fetchMovieDetails(int movieId) {
    HttpClient()
        .getUrl(Uri.parse(
            "https://api.themoviedb.org/3/movie/$movieId?api_key=${TMDB.key}")) //
        // produces a request object
        .then((request) => request.close()) // sends the request
        .then((response) {
      response.transform(utf8.decoder).join().then((detailsJson) {
        Map mapJson = json.decode(detailsJson);
        MovieDetails _movieDetails = MovieDetails.fromJson(mapJson);
        favMovieList.add(_movieDetails);
        favMovieList = favMovieList.toSet().toList();
        favMovieList.sort((a, b) => b.id.compareTo(a.id));
        setState(() {});
      }).catchError((e) {
        print(e);
        setState(() {});
      });
    });
  }
}
