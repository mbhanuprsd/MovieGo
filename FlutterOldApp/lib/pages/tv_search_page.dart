import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:movie_go/listitems/movie_item.dart';
import 'package:movie_go/models/tv_search_model.dart';
import 'package:movie_go/tmdb.dart';
import 'package:movie_go/utils/app_util.dart';

class TVSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TVSearchPageState();
}

class TVSearchPageState extends State<TVSearchPage> {
  String logMessage;
  String searchString;
  int pageNumber = 1;
  List<TVInfo> tvList;
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
          decoration:
              BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).accentColor, width: 3.0))),
          child: TextField(
            maxLines: 1,
            onChanged: (str) {
              searchString = str;
            },
            autofocus: true,
            style: TextStyle(fontSize: 20.0, color: Theme.of(context).accentColor),
          ),
        ),
        actions: <Widget>[
          searching
              ? Container()
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: searchTv,
                ),
        ],
      ),
      body: searching
          ? Center(
              child: new CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              ),
            )
          : (tvList == null || tvList.length == 0)
              ? Center(
                  child: new Text(
                    'No Series Found',
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
                    buildTvList(),
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
            items: <String>['Popularity', 'Name'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: CustomText(value, 18.0, true, Colors.white, 1),
              );
            }).toList(),
            onChanged: (value) {
              selectedSort = value;
              sortTv(value);
            },
          ),
        ],
      ),
    );
  }

  void sortTv(String value) {
    switch (value) {
      case 'Popularity':
        tvList.sort((a, b) => b.popularity.compareTo(a.popularity));
        break;
      case 'Name':
        tvList.sort((a, b) => a.name.compareTo(b.name));
        break;
    }
    if (mounted) setState(() {});
  }

  Widget buildTvList() {
    return Expanded(
      child: Scrollbar(
        child: new ListView.builder(
            controller: controller,
            itemCount: tvList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return new TvListItem(tvList[index]);
            }),
      ),
    );
  }

  bool searching = false;
  searchTv() {
    tvList = new List();
    pageNumber = 1;
    FocusScope.of(context).requestFocus(new FocusNode());
    if (searchString != null && searchString.length > 1 && !searching) {
      searching = true;
      if (mounted) setState(() {});
      AppUtils.isNetworkConnected().then((connected) {
        if (connected) {
          getTvList();
        } else {
          AppUtils.showAlert(context, 'No intenet connection', null, 'Ok', null);
          searching = false;
          if (mounted) setState(() {});
        }
      });
    }
  }

  void getTvList() {
    print("Tv page no : $pageNumber");
    HttpClient()
        .getUrl(Uri.parse(
            "https://api.themoviedb.org/3/search/tv?api_key=${TMDB.key}&language=en-US&query=$searchString&page=$pageNumber"))
        // produces a request object
        .then((request) => request.close()) // sends the request
        .then((response) {
      response.transform(utf8.decoder).join().then((jsonString) {
        Map mapJson = json.decode(jsonString);
        TVSearchModel data = TVSearchModel.fromJson(mapJson);
        if (tvList == null || tvList.length == 0) {
          tvList = data.results;
        } else {
          tvList.addAll(data.results);
        }
        tvList = tvList.toSet().toList();
        if (selectedSort != null) {
          sortTv(selectedSort);
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
      getTvList();
    }
  }
}
