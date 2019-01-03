import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
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
  String selectedSort;

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
      body: searching
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
              : Column(
                  children: <Widget>[
                    buildDropdownButton(),
                    buildPeopleList(),
                  ],
                ),
    );
  }

  Widget buildDropdownButton() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          new CustomText('Sort by', 18.0, true, Colors.white, 1),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
          ),
          new DropdownButton<String>(
            value: selectedSort,
            hint: new CustomText('Select', 18.0, true, Colors.white, 1),
            items: <String>['Popularity', 'Name', 'Release Date']
                .map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: CustomText(value, 18.0, true, Colors.white, 1),
              );
            }).toList(),
            onChanged: (value) {
              selectedSort = value;
              sortMovies(value);
            },
          ),
        ],
      ),
    );
  }

  void sortMovies(String value) {
    switch (value) {
      case 'Popularity':
        movieList.sort((a, b) => b.popularity.compareTo(a.popularity));
        break;
      case 'Name':
        movieList.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Release Date':
        movieList.sort((a, b) => DateTime.tryParse(b.releaseDate)
            .compareTo(DateTime.tryParse(a.releaseDate)));
        break;
    }
    if (mounted) setState(() {});
  }

  Widget buildPeopleList() {
    return Expanded(
      child: Scrollbar(
        child: new ListView.builder(
            controller: controller,
            itemCount: movieList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return new MovieListItem(movieList[index]);
            }),
      ),
    );
  }

  bool searching = false;
  searchMovies() {
    movieList = new List();
    FocusScope.of(context).requestFocus(new FocusNode());
    if (searchString != null && searchString.length > 1 && !searching) {
      searching = true;
      if (mounted) setState(() {});
      AppUtils.isNetworkConnected().then((connected) {
        if (connected) {
          getMovies();
        } else {
          AppUtils.showAlert(
              context, 'No intenet connection', null, 'Ok', null);
          searching = false;
          if (mounted) setState(() {});
        }
      });
    }
  }

  void getMovies() {
    print("Movies page no : $pageNumber");
    HttpClient()
        .getUrl(Uri.parse(
            "https://api.themoviedb.org/3/search/movie?api_key=${TMDB.key}&language=en-US&query=$searchString&page=$pageNumber")) //
        // produces a request object
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
        if (selectedSort != null) {
          sortMovies(selectedSort);
        }
        searching = false;
        if (mounted) setState(() {});
      }).catchError((e) {
        print(e);
        searching = false;
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
