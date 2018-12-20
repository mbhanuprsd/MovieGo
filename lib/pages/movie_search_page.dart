import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_go/listitems/movie_item.dart';
import 'package:movie_go/models/movie_search_model.dart';
import 'package:movie_go/tmdb.dart';
import 'package:movie_go/utils/app_util.dart';

class MovieSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MovieSearchPageState();
}

class MovieSearchPageState extends State<MovieSearchPage> {
  String logMessage;
  String searchString;
  int pageNumber = 1;
  List<MovieInfo> movieList;
  ScrollController controller;

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).accentColor, width: 3.0))),
          child: TextField(
            maxLines: 1,
            onChanged: (str) {
              searchString = str;
            },
            autofocus: true,
            style:
                TextStyle(fontSize: 20.0, color: Theme.of(context).accentColor),
          ),
        ),
        actions: <Widget>[
          searching
              ? Container()
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: searchMovies,
                ),
        ],
      ),
      body: new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            searching
                ? Center(
                    child: new CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  )
                : (movieList == null || movieList.length == 0)
                    ? Center(
                        child: new Text(
                          'No Movies Found',
                          style: new TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : new Expanded(
                        child: new Scrollbar(
                          child: new ListView.builder(
                              controller: controller,
                              itemCount: movieList.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return new MovieListItem(movieList[index]);
                              }),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  bool searching = false;
  searchMovies() {
    movieList = new List();
    FocusScope.of(context).requestFocus(new FocusNode());
    if (searchString != null && searchString.length > 1 && !searching) {
      searching = true;
      setState(() {});
      AppUtils.isNetworkConnected().then((connected) {
        if (connected) {
          getMovies();
        } else {
          AppUtils.showAlert(
              context, 'No intenet connection', null, 'Ok', null);
          searching = false;
          setState(() {});
        }
      });
    }
  }

  void getMovies() {
    HttpClient()
        .getUrl(Uri.parse("https://api.themoviedb.org/3/search/movie?api_key=" +
            TMDB.key +
            "&language=en-US&query=$searchString&page=$pageNumber&include_adult=false")) // produces a request object
        .then((request) => request.close()) // sends the request
        .then((response) {
      response.transform(utf8.decoder).join().then((jsonString) {
        Map mapJson = json.decode(jsonString);
        MovieSearchData data = MovieSearchData.fromJson(mapJson);
        if (movieList == null || movieList.length == 0) {
          movieList = data.results;
        } else {
          movieList.addAll(data.results);
        }
        movieList = movieList.toSet().toList();
        searching = false;
        setState(() {});
      }).catchError((e) {
        print(e);
        searching = false;
        setState(() {});
      });
    });
  }

  void _scrollListener() {
    print(controller.position.extentAfter);
    if (controller.position.extentAfter < 500) {
      pageNumber++;
      getMovies();
    }
  }
}
