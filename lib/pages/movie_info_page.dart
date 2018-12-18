import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:movie_go/listitems/cast_crew_item.dart';
import 'package:movie_go/models/cast_crew_details.dart';
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
  String generes;
  CastCrewDetails castCrewDetails;

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
                              movieInfo.backdropPath == null
                                  ? movieInfo.posterPath
                                  : movieInfo.backdropPath)),
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
                            Image(
                              image: CachedNetworkImageProvider(
                                ImageUtils.getFullImagePath(
                                    movieInfo.posterPath),
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
                                      "Release Date : ${_movieDetails.releaseDate}",
                                      16.0,
                                      false,
                                      Colors.white,
                                      null),
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
                        CustomText("Genre : $generes", 16.0, false,
                            Colors.white, null),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                        ),
                        CustomText("Crew :", 20.0, true, Colors.white, null),
                        (castCrewDetails?.crew == null ||
                                castCrewDetails?.crew?.length == 0)
                            ? Center(
                                child: CustomText(
                                    "No Crew", 16.0, false, Colors.white, 1))
                            : GridView.count(
                                crossAxisCount: 1,
                                scrollDirection: Axis.horizontal,
                                physics: ScrollPhysics(),
                                children: List.generate(
                                    castCrewDetails.crew.length, (index) {
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
            "https://api.themoviedb.org/3/movie/${movieInfo.id}?api_key=${TMDB.key}")) // produces a request object
        .then((request) => request.close()) // sends the request
        .then((response) {
      response.transform(utf8.decoder).join().then((detailsJson) {
        HttpClient()
            .getUrl(Uri.parse(
                "https://api.themoviedb.org/3/movie/${movieInfo.id}/credits?api_key=${TMDB.key}"))
            .then((request) => request.close())
            .then((response) {
          response.transform(utf8.decoder).join().then((creditsJson) {
            Map creditsmap = json.decode(creditsJson);
            castCrewDetails = CastCrewDetails.fromJson(creditsmap);
            setState(() {});
          });
        });

        Map mapJson = json.decode(detailsJson);
        _movieDetails = MovieDetails.fromJson(mapJson);
        List<String> genereList = new List();
        for (var item in _movieDetails.genres) {
          genereList.add(item.name);
        }
        generes = genereList.join(', ');
        setState(() {});
      }).catchError((e) {
        print(e);
        setState(() {});
      });
    });
  }
}
