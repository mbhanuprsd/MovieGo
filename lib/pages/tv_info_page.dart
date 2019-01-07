import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:movie_go/firestore/firestore_manager.dart';
import 'package:movie_go/listitems/cast_crew_item.dart';
import 'package:movie_go/listitems/movie_item.dart';
import 'package:movie_go/models/cast_crew_details.dart';
import 'package:movie_go/models/tv_details.dart';
import 'package:movie_go/tmdb.dart';
import 'package:movie_go/utils/image_util.dart';
import 'package:movie_go/utils/navigator_util.dart';

class TVInfoPage extends StatefulWidget {
  final int tvId;
  TVInfoPage(this.tvId);

  @override
  State<StatefulWidget> createState() => TVInfoPageState(tvId);
}

class TVInfoPageState extends State<TVInfoPage> {
  int tvId;
  TVInfoPageState(this.tvId);
  TVDetails _tvDetails;
  CastCrewDetails castCrewDetails;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    fetchTvDetails();
    FireStoreManager.isTVBookMarked(tvId).then((marked) {
      isBookmarked = marked;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print("${_tvDetails?.name} : $tvId");
    return Scaffold(
      appBar: AppBar(
        title: Text(_tvDetails?.name ?? "Loading..."),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => MyNavigator.goToHome(context),
          ),
          IconButton(
            icon: Icon(isBookmarked ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              FireStoreManager.toggleTVBookMark(tvId).then((_) {
                isBookmarked = !isBookmarked;
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: _tvDetails == null
          ? Center(
              child: CustomProgress(context),
            )
          : Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: new CachedNetworkImageProvider(ImageUtils.getFullImagePath(
                          _tvDetails.backdropPath == null ? _tvDetails.posterPath : _tvDetails.backdropPath)),
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
                              imageUrl: ImageUtils.getFullImagePath(_tvDetails.posterPath),
                              placeholder: new CircularProgressIndicator(),
                              errorWidget: new Icon(Icons.live_tv),
                              height: 200.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.0),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomText(
                                      _tvDetails.originalName == _tvDetails.name
                                          ? _tvDetails.originalName
                                          : _tvDetails.originalName + " (${_tvDetails.name})",
                                      20.0,
                                      true,
                                      Colors.white,
                                      2),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                  CustomText("Aired : ${_tvDetails.firstAirDate} - ${_tvDetails.lastAirDate}", 16.0,
                                      false, Colors.white, null),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                  StarRating(
                                    starCount: 5,
                                    rating: _tvDetails.voteAverage / 2.0,
                                  ),
                                  CustomText("Votes : ${_tvDetails.voteCount}", 16.0, false, Colors.white, null),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                  ),
                                  CustomText(
                                      "No of Seasons : ${_tvDetails.numberOfSeasons}", 16.0, false, Colors.white, 2),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                        ),
                        CustomText("Description : \n${_tvDetails.overview}", 16.0, false, Colors.white, null),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                        ),
                        CustomText("Seasons :", 20.0, true, Colors.white, null),
                        Container(
                          height: 240.0,
                          child: (_tvDetails?.seasons == null || _tvDetails?.seasons?.length == 0)
                              ? _tvDetails?.seasons == null
                                  ? Center(child: CustomProgress(context))
                                  : Center(
                                      child: CenterText("Not Available", 20.0, true, Theme.of(context).primaryColor, 1))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _tvDetails.seasons.length,
                                  itemBuilder: (ctxt, index) {
                                    return new SeasonDetail(_tvDetails.seasons[index]);
                                  }),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                        ),
                        CustomText("Cast :", 20.0, true, Colors.white, null),
                        Container(
                          height: 240.0,
                          child: (castCrewDetails?.cast == null || castCrewDetails?.cast?.length == 0)
                              ? castCrewDetails == null
                                  ? Center(child: CustomProgress(context))
                                  : Center(
                                      child: CenterText("Not Available", 20.0, true, Theme.of(context).primaryColor, 1))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: castCrewDetails.cast.length,
                                  itemBuilder: (ctxt, index) {
                                    return new CastItem(castCrewDetails.cast[index]);
                                  }),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.0),
                        ),
                        CustomText("Crew :", 20.0, true, Colors.white, null),
                        Container(
                          height: 240.0,
                          child: (castCrewDetails?.crew == null || castCrewDetails?.crew?.length == 0)
                              ? castCrewDetails == null
                                  ? Center(child: CustomProgress(context))
                                  : Center(
                                      child: CenterText("Not Available", 20.0, true, Theme.of(context).primaryColor, 1))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: castCrewDetails.crew.length,
                                  itemBuilder: (ctxt, index) {
                                    return new CrewItem(castCrewDetails.crew[index]);
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

  fetchTvDetails() {
    HttpClient()
        .getUrl(Uri.parse("https://api.themoviedb.org/3/tv/$tvId?api_key=${TMDB.key}")) //
        // produces a request object
        .then((request) => request.close()) // sends the request
        .then((response) {
      response.transform(utf8.decoder).join().then((detailsJson) {
        fetchCredentials();

        Map mapJson = json.decode(detailsJson);
        _tvDetails = TVDetails.fromJson(mapJson);
        if (mounted) setState(() {});
      }).catchError((e) {
        print(e);
      });
    });
  }

  fetchCredentials() {
    HttpClient()
        .getUrl(Uri.parse("https://api.themoviedb"
            ".org/3/tv/$tvId/credits?api_key=${TMDB.key}"))
        .then((request) => request.close())
        .then((response) {
      response.transform(utf8.decoder).join().then((creditsJson) {
        Map creditsmap = json.decode(creditsJson);
        castCrewDetails = CastCrewDetails.fromJson(creditsmap);
        if (mounted) setState(() {});
      });
    });
  }
}

class SeasonDetail extends StatelessWidget {
  final Seasons seasions;
  SeasonDetail(this.seasions);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Container(
        width: 150.0,
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        child: new GestureDetector(
          onTap: null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              (seasions.posterPath == null)
                  ? Icon(
                      Icons.account_circle,
                      color: Theme.of(context).primaryColor,
                      size: 120.0,
                    )
                  : CachedNetworkImage(
                      imageUrl: ImageUtils.getFullImagePath(seasions.posterPath),
                      placeholder: Icon(
                        Icons.live_tv,
                        color: Theme.of(context).primaryColor,
                        size: 120.0,
                      ),
                      errorWidget: new Icon(Icons.error),
                      height: 120.0,
                    ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
              ),
              CenterText(seasions.name, 14.0, true, Colors.white, 2),
              CenterText("Episodes: ${seasions.episodeCount}", 14.0, true, Colors.white, 2),
              CenterText("Aired : ${seasions.airDate}", 14.0, true, Theme.of(context).primaryColor, 2),
            ],
          ),
        ),
      ),
    );
  }
}
