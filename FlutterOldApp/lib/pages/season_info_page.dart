import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:movie_go/listitems/movie_item.dart';
import 'package:movie_go/models/movie_video_model.dart';
import 'package:movie_go/models/season_info.dart';
import 'package:movie_go/tmdb.dart';
import 'package:movie_go/utils/image_util.dart';
import 'package:movie_go/utils/navigator_util.dart';

class SeasonInfoPage extends StatefulWidget {
  final int seasonNumber;
  final int tvId;
  SeasonInfoPage(this.tvId, this.seasonNumber);

  @override
  State<StatefulWidget> createState() => _SeasonInfoPageState(tvId, seasonNumber);
}

class _SeasonInfoPageState extends State<SeasonInfoPage> {
  final int seasonNumber;
  final int tvId;
  _SeasonInfoPageState(this.tvId, this.seasonNumber);
  SeasonInfo _seasonInfo;
  MovieVideoModel _movieVideoModel;

  @override
  void initState() {
    super.initState();
    fetchSeasonDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_seasonInfo?.name ?? "Loading..."),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => MyNavigator.goToHome(context),
          ),
        ],
      ),
      body: _seasonInfo == null
          ? Center(
              child: CustomProgress(context),
            )
          : Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: new CachedNetworkImageProvider(ImageUtils.getFullImagePath(_seasonInfo.posterPath)),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Color.fromARGB(200, 0, 0, 0)),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 2.0),
                        ),
                        CustomText("Videos :", 20.0, true, Colors.white, null),
                        buildVideos(context),
                        Padding(
                          padding: EdgeInsets.only(top: 2.0),
                        ),
                        CustomText("Episodes : ${_seasonInfo?.episodes?.length}", 20.0, true, Colors.white, null),
                        Container(
                          height: 380.0,
                          child: _seasonInfo?.episodes == null
                              ? Container()
                              : Scrollbar(
                                  child: GridView.count(
                                    scrollDirection: Axis.horizontal,
                                    crossAxisCount: 1,
                                    children: _seasonInfo.episodes.map((episode) {
                                      return new EpisodeListItem(episode);
                                    }).toList(),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Container buildVideos(BuildContext context) {
    return Container(
      height: 240.0,
      child: (_movieVideoModel?.results == null || _movieVideoModel?.results?.length == 0)
          ? _movieVideoModel == null
              ? Center(child: CustomProgress(context))
              : Center(child: CenterText("Not Available", 20.0, true, Theme.of(context).primaryColor, 1))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _movieVideoModel.results.length,
              itemBuilder: (ctxt, index) {
                return VideoItem(_movieVideoModel.results[index]);
              }),
    );
  }

  fetchVideos() {
    HttpClient()
        .getUrl(Uri.parse("https://api.themoviedb"
            ".org/3/tv/$tvId/season/$seasonNumber/videos?api_key=${TMDB.key}&language=en-US"))
        .then((request) => request.close())
        .then((response) {
      response.transform(utf8.decoder).join().then((creditsJson) {
        Map videosmap = json.decode(creditsJson);
        _movieVideoModel = MovieVideoModel.fromJson(videosmap);
        _movieVideoModel.results = _movieVideoModel.results.where((video) => video.site == "YouTube").toList();
        if (mounted) setState(() {});
      });
    });
  }

  fetchSeasonDetails() {
    HttpClient()
        .getUrl(Uri.parse("https://api.themoviedb.org/3/tv/$tvId/season/$seasonNumber?api_key=${TMDB.key}")) //
        // produces a request object
        .then((request) => request.close()) // sends the request
        .then((response) {
      response.transform(utf8.decoder).join().then((detailsJson) {
        fetchVideos();
        Map mapJson = json.decode(detailsJson);
        _seasonInfo = SeasonInfo.fromJson(mapJson);
        if (mounted) setState(() {});
      }).catchError((e) {
        print(e);
      });
    });
  }
}

class EpisodeListItem extends StatelessWidget {
  final Episodes episode;
  EpisodeListItem(this.episode);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            (episode.stillPath == null)
                ? Icon(
                    Icons.live_tv,
                  )
                : CachedNetworkImage(
                    imageUrl: ImageUtils.getFullImagePath(episode.stillPath),
                    placeholder: new CircularProgressIndicator(),
                    errorWidget: new Icon(Icons.error),
                  ),
            CustomText("${episode.episodeNumber}. ${episode.name}", 20.0, true, Colors.white, 2),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: <Widget>[
                episode.airDate == null
                    ? Container()
                    : CustomText("Aired: ${episode.airDate}", 16.0, false, Colors.white, 1),
                Expanded(
                  child: Container(),
                  flex: 1,
                ),
                StarRating(
                  starCount: 5,
                  rating: episode.voteAverage / 2.0,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            episode.overview == null ? Container() : CustomText(episode.overview, 14.0, false, Colors.white, 3),
          ],
        ),
      ),
    );
  }
}
