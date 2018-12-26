import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:movie_go/firestore/firestore_manager.dart';
import 'package:movie_go/listitems/cast_crew_item.dart';
import 'package:movie_go/models/cast_crew_details.dart';
import 'package:movie_go/models/movie_details.dart';
import 'package:movie_go/tmdb.dart';
import 'package:movie_go/utils/image_util.dart';
import 'package:movie_go/utils/navigator_util.dart';

class MovieInfoPage extends StatefulWidget {
  final int movieId;
  MovieInfoPage(this.movieId);

  @override
  State<StatefulWidget> createState() => MovieInfoPageState(movieId);
}

class MovieInfoPageState extends State<MovieInfoPage> {
  int movieId;
  MovieInfoPageState(this.movieId);
  MovieDetails _movieDetails;
  String generes;
  CastCrewDetails castCrewDetails;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
    FireStoreManager.isMovieBookMarked(movieId).then((marked) {
      isBookmarked = marked;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print("${_movieDetails?.title} : $movieId");
    return Scaffold(
      appBar: AppBar(
        title: Text(_movieDetails?.title ?? "Loading..."),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => MyNavigator.goToHome(context),
          ),
          IconButton(
            icon: Icon(isBookmarked ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              FireStoreManager.toggleMovieBookMark(movieId).then((_) {
                isBookmarked = !isBookmarked;
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: _movieDetails == null
          ? Center(
              child: CustomProgress(context),
            )
          : Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: new CachedNetworkImageProvider(
                          ImageUtils.getFullImagePath(
                              _movieDetails.backdropPath == null
                                  ? _movieDetails.posterPath
                                  : _movieDetails.backdropPath)),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Container(
                  decoration:
                      BoxDecoration(color: Color.fromARGB(200, 0, 0, 0)),
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
                              imageUrl: ImageUtils.getFullImagePath(
                                  _movieDetails.posterPath),
                              placeholder: new CircularProgressIndicator(),
                              errorWidget: new Icon(Icons.movie_filter),
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
                                      _movieDetails.originalTitle ==
                                              _movieDetails.title
                                          ? _movieDetails.originalTitle
                                          : _movieDetails.originalTitle +
                                              " (${_movieDetails.title})",
                                      20.0,
                                      true,
                                      Colors.white,
                                      2),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                  CustomText(
                                      "Release Date : ${_movieDetails.releaseDate}",
                                      16.0,
                                      false,
                                      Colors.white,
                                      null),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                  StarRating(
                                    starCount: 5,
                                    rating: _movieDetails.voteAverage / 2.0,
                                  ),
                                  CustomText(
                                      "Votes : ${_movieDetails.voteCount}",
                                      16.0,
                                      false,
                                      Colors.white,
                                      null),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                  ),
                                  CustomText("Genre : $generes", 16.0, false,
                                      Colors.white, 2),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                        ),
                        CustomText("Description : \n${_movieDetails.overview}",
                            16.0, false, Colors.white, null),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                        ),
                        CustomText("Cast :", 20.0, true, Colors.white, null),
                        Container(
                          height: 240.0,
                          child: (castCrewDetails?.cast == null ||
                                  castCrewDetails?.cast?.length == 0)
                              ? castCrewDetails == null
                                  ? Center(child: CustomProgress(context))
                                  : Center(
                                      child: CenterText(
                                          "Not Available",
                                          20.0,
                                          true,
                                          Theme.of(context).primaryColor,
                                          1))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: castCrewDetails.cast.length,
                                  itemBuilder: (ctxt, index) {
                                    return new CastItem(
                                        castCrewDetails.cast[index]);
                                  }),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.0),
                        ),
                        CustomText("Crew :", 20.0, true, Colors.white, null),
                        Container(
                          height: 240.0,
                          child: (castCrewDetails?.crew == null ||
                                  castCrewDetails?.crew?.length == 0)
                              ? castCrewDetails == null
                                  ? Center(child: CustomProgress(context))
                                  : Center(
                                      child: CenterText(
                                          "Not Available",
                                          20.0,
                                          true,
                                          Theme.of(context).primaryColor,
                                          1))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: castCrewDetails.crew.length,
                                  itemBuilder: (ctxt, index) {
                                    return new CrewItem(
                                        castCrewDetails.crew[index]);
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

  fetchMovieDetails() {
    HttpClient()
        .getUrl(Uri.parse(
            "https://api.themoviedb.org/3/movie/$movieId?api_key=${TMDB.key}")) //
        // produces a request object
        .then((request) => request.close()) // sends the request
        .then((response) {
      response.transform(utf8.decoder).join().then((detailsJson) {
        fetchCredentials();

        Map mapJson = json.decode(detailsJson);
        _movieDetails = MovieDetails.fromJson(mapJson);
        generes = _movieDetails.genres?.map((g) => g.name)?.toList()?.join(','
            ' ');
        setState(() {});
      }).catchError((e) {
        print(e);
        setState(() {});
      });
    });
  }

  fetchCredentials() {
    HttpClient()
        .getUrl(Uri.parse("https://api.themoviedb"
            ".org/3/movie/$movieId/credits?api_key=${TMDB.key}"))
        .then((request) => request.close())
        .then((response) {
      response.transform(utf8.decoder).join().then((creditsJson) {
        Map creditsmap = json.decode(creditsJson);
        castCrewDetails = CastCrewDetails.fromJson(creditsmap);
        setState(() {});
      });
    });
  }
}
