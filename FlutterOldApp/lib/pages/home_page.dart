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
import 'package:movie_go/models/people_info.dart';
import 'package:movie_go/models/tv_details.dart';
import 'package:movie_go/tmdb.dart';
import 'package:movie_go/utils/app_util.dart';
import 'package:movie_go/utils/navigator_util.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  FirebaseUser curentUser;
  List<MovieDetails> favMovieList;
  List<PersonDetail> favPersonList;
  List<TVDetails> favTvList;

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
    new DrawerItem("Search Movies", Icons.movie_filter),
    new DrawerItem("Search People", Icons.account_circle),
    new DrawerItem("Search TV", Icons.live_tv),
    new DrawerItem("Developer", Icons.info),
    new DrawerItem("Logout", Icons.exit_to_app)
  ];

  _onSelectItem(int index) {
    print(index);
    switch (index) {
      case 0:
        MyNavigator.goToMovieSearch(context);
        break;
      case 1:
        MyNavigator.goToPeopleSearch(context);
        break;
      case 2:
        MyNavigator.goToTVSearch(context);
        break;
      case 3:
        MyNavigator.goToDeveloperInfo(context, curentUser?.displayName);
        break;
      case 4:
        logout();
        break;
    }
  }

  void logout() {
    _auth.signOut().then((_) {
      AppUtils.showConditionalAlert(context, "Do you want to logout?", null, "Yes", () {
        MyNavigator.goToLogin(context);
      }, "No", () => Navigator.of(context).pop());
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> getDrawerOptions(BuildContext bldContext) {
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
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
          ),
          selected: i == _selectedIndex,
          onTap: () {
            Navigator.of(bldContext).pop();
            _onSelectItem(i);
          },
        ));
      }
      return drawerOptions;
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: logout,
          ),
        ],
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: CustomText(curentUser?.displayName ?? "", 18.0, true, Theme.of(context).primaryColor, 1),
              accountEmail: CustomText(curentUser?.email ?? "", 18.0, true, Theme.of(context).primaryColor, 1),
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
                decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                child: new Column(
                  children: getDrawerOptions(context),
                ),
              ),
            ),
          ],
        ),
      ),
      body: buildHomeWidget(context),
    );
  }

  Widget buildHomeWidget(BuildContext context) {
    return Stack(
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
                      "Welcome ${curentUser == null ? "" : curentUser.displayName}!", 16.0, true, Colors.white, 2),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                ),
                CustomText("Favorite Movies:", 20.0, true, Colors.white, 1),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                buildFavMovieList(context),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                ),
                CustomText("Favorite TV:", 20.0, true, Colors.white, 1),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                buildFavTvList(context),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                ),
                CustomText("Favorite People:", 20.0, true, Colors.white, 1),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                buildFavPeopleList(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFavPeopleList(BuildContext context) {
    return Container(
      height: 200.0,
      child: (favPersonList == null || favPersonList?.length == 0)
          ? Center(child: CenterText("No Favourites", 20.0, true, Theme.of(context).primaryColor, 1))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: favPersonList.length,
              itemBuilder: (ctxt, index) {
                return new FavPersonItem(favPersonList[index]);
              }),
    );
  }

  Widget buildFavMovieList(BuildContext context) {
    return Container(
      height: 200.0,
      child: (favMovieList == null || favMovieList?.length == 0)
          ? Center(child: CenterText("No Favourites", 20.0, true, Theme.of(context).primaryColor, 1))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: favMovieList.length,
              itemBuilder: (ctxt, index) {
                return new FavMovieItem(favMovieList[index]);
              }),
    );
  }

  Widget buildFavTvList(BuildContext context) {
    return Container(
      height: 200.0,
      child: (favTvList == null || favTvList?.length == 0)
          ? Center(child: CenterText("No Favourites", 20.0, true, Theme.of(context).primaryColor, 1))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: favTvList.length,
              itemBuilder: (ctxt, index) {
                return new FavTvItem(favTvList[index]);
              }),
    );
  }

  bool bookmarksAvailable = false;
  fetchBookmarks() {
    Firestore.instance.collection(curentUser.uid)?.snapshots()?.listen((qs) async {
      favMovieList = new List();
      favPersonList = new List();
      await fetchMovieBookmarks(qs);
      await fetchPeopleBookmarks(qs);
      await fetchTVBookmarks(qs);
    });
  }

  Future<void> fetchPeopleBookmarks(QuerySnapshot qs) async {
    bookmarksAvailable = false;
    if (qs != null && qs.documents != null && qs.documents.length > 0) {
      DocumentSnapshot docSnap =
          qs.documents?.firstWhere((doc) => doc?.data?.containsKey(FireStoreManager.fsPersonBookmarkDoc));
      if (docSnap != null) {
        String bookMarksString = docSnap.data[FireStoreManager.fsPersonBookmarkDoc].toString();
        if (bookMarksString.length > 0) {
          List<String> strings = bookMarksString.split(',').toList();
          if (strings != null && strings.length > 0) {
            List<int> bookMarks = strings.map((id) => int.parse(id)).toList();
            favPersonList = new List();
            for (var id in bookMarks) {
              fetchPersonDetails(id);
            }
            bookmarksAvailable = true;
          }
        }
      }
    }
    if (!bookmarksAvailable) favPersonList = new List();
    bookmarksAvailable = false;
  }

  fetchPersonDetails(int personId) {
    HttpClient()
        .getUrl(Uri.parse("https://api.themoviedb"
            ".org/3/person/$personId?api_key=${TMDB.key}&language=en-US"))
        .then((request) => request.close()) // sends the request
        .then((response) {
      response.transform(utf8.decoder).join().then((detailsJson) {
        Map mapJson = json.decode(detailsJson);
        PersonDetail _personDetails = PersonDetail.fromJson(mapJson);
        favPersonList.add(_personDetails);
        favPersonList = favPersonList.toSet().toList();
        favPersonList.sort((a, b) => b.id.compareTo(a.id));
        setState(() {});
      }).catchError((e) {
        print(e);
        favPersonList = new List();
        setState(() {});
      });
    });
  }

  Future<void> fetchMovieBookmarks(QuerySnapshot qs) async {
    bookmarksAvailable = false;
    if (qs != null && qs.documents != null && qs.documents.length > 0) {
      DocumentSnapshot docSnap =
          qs.documents?.firstWhere((doc) => doc?.data?.containsKey(FireStoreManager.fsMovieBookmarkDoc));
      if (docSnap != null) {
        String bookMarksString = docSnap.data[FireStoreManager.fsMovieBookmarkDoc].toString();
        if (bookMarksString.length > 0) {
          List<String> strings = bookMarksString.split(',').toList();
          if (strings != null && strings.length > 0) {
            List<int> bookMarks = strings.map((id) => int.parse(id)).toList();
            favMovieList = new List();
            for (var id in bookMarks) {
              fetchMovieDetails(id);
            }
            bookmarksAvailable = true;
          }
        }
      }
    }
    if (!bookmarksAvailable) favMovieList = new List();
    bookmarksAvailable = false;
  }

  fetchMovieDetails(int movieId) {
    HttpClient()
        .getUrl(Uri.parse("https://api.themoviedb.org/3/movie/$movieId?api_key=${TMDB.key}")) //
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
        favMovieList = new List();
        setState(() {});
      });
    });
  }

  Future<void> fetchTVBookmarks(QuerySnapshot qs) async {
    bookmarksAvailable = false;
    if (qs != null && qs.documents != null && qs.documents.length > 0) {
      DocumentSnapshot docSnap =
          qs.documents?.firstWhere((doc) => doc?.data?.containsKey(FireStoreManager.fsTVBookmarkDoc));
      if (docSnap != null) {
        String bookMarksString = docSnap.data[FireStoreManager.fsTVBookmarkDoc].toString();
        if (bookMarksString.length > 0) {
          List<String> strings = bookMarksString.split(',').toList();
          if (strings != null && strings.length > 0) {
            List<int> bookMarks = strings.map((id) => int.parse(id)).toList();
            favTvList = new List();
            for (var id in bookMarks) {
              fetchTvDetails(id);
            }
            bookmarksAvailable = true;
          }
        }
      }
    }
    if (!bookmarksAvailable) favMovieList = new List();
    bookmarksAvailable = false;
  }

  fetchTvDetails(int tvId) {
    HttpClient()
        .getUrl(Uri.parse("https://api.themoviedb.org/3/tv/$tvId?api_key=${TMDB.key}")) //
        // produces a request object
        .then((request) => request.close()) // sends the request
        .then((response) {
      response.transform(utf8.decoder).join().then((detailsJson) {
        Map mapJson = json.decode(detailsJson);
        TVDetails _tvDetails = TVDetails.fromJson(mapJson);
        favTvList.add(_tvDetails);
        favTvList = favTvList.toSet().toList();
        favTvList.sort((a, b) => b.id.compareTo(a.id));
        setState(() {});
      }).catchError((e) {
        print(e);
        favTvList = new List();
        setState(() {});
      });
    });
  }
}
