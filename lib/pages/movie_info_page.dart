import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:movie_go/models/movie_details.dart';
import 'package:movie_go/models/movie_search_model.dart';
import 'package:movie_go/tmdb.dart';
import 'package:movie_go/utils/image_util.dart';

class MovieInfoPage extends StatefulWidget {
  final MovieInfo movieInfo;
  MovieInfoPage(this.movieInfo);

  @override
  State<StatefulWidget> createState() => MovieInfoPageState(movieInfo);
}

class MovieInfoPageState extends State<MovieInfoPage> {
  MovieInfo movieInfo;
  MovieInfoPageState(this.movieInfo);
  MovieDetails _movieDetails;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movieInfo?.title),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: new CachedNetworkImageProvider(
                    ImageUtils.getFullImagePath(movieInfo.backdropPath)),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Color.fromARGB(200, 0, 0, 0)),
          ),
          _movieDetails == null
              ? Center(
                  child: CustomProgress(context),
                )
              : Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image(
                            image: CachedNetworkImageProvider(
                              ImageUtils.getFullImagePath(movieInfo.posterPath),
                            ),
                            height: 200.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomText(_movieDetails.originalTitle, 20.0,
                                    true, Colors.white, 2),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                ),
                                CustomText(
                                    "Release Date : ${_movieDetails.releaseDate}\nRating : ${_movieDetails.voteAverage}/10\nVotes : ${_movieDetails.voteCount}",
                                    16.0,
                                    false,
                                    Colors.white,
                                    null),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: CustomText(
                            "Description : \n${_movieDetails.overview}",
                            16.0,
                            false,
                            Colors.white,
                            null),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  fetchMovieDetails() {
    HttpClient()
        .getUrl(Uri.parse(
            "https://api.themoviedb.org/3/movie/${movieInfo.id}?api_key=${TMDB.key}")) // produces a request object
        .then((request) => request.close()) // sends the request
        .then((response) {
      response.transform(utf8.decoder).join().then((jsonString) {
        Map mapJson = json.decode(jsonString);
        _movieDetails = MovieDetails.fromJson(mapJson);
        setState(() {});
      }).catchError((e) {
        print(e);
        setState(() {});
      });
    });
  }
}
