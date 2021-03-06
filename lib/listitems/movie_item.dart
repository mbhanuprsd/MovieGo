import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:movie_go/firestore/firestore_manager.dart';
import 'package:movie_go/models/movie_details.dart';
import 'package:movie_go/models/movie_search_model.dart';
import 'package:movie_go/models/movie_video_model.dart';
import 'package:movie_go/models/people_info.dart';
import 'package:movie_go/models/people_search_model.dart';
import 'package:movie_go/models/people_tv_credits.dart';
import 'package:movie_go/models/tv_details.dart';
import 'package:movie_go/models/tv_search_model.dart';
import 'package:movie_go/tmdb.dart';
import 'package:movie_go/utils/app_util.dart';
import 'package:movie_go/utils/image_util.dart';
import 'package:movie_go/utils/navigator_util.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

class MovieListItem extends StatelessWidget {
  final MovieInfo movieInfo;
  MovieListItem(this.movieInfo);

  @override
  Widget build(BuildContext context) {
    return PosterListItem(
        movieInfo.posterPath,
        movieInfo.title,
        "Rating : ${movieInfo.voteAverage}/10 (${movieInfo.voteCount})",
        "Released on : " + movieInfo.releaseDate,
        movieInfo.overview,
        () => MyNavigator.goToMovieInfo(context, movieInfo.id));
  }
}

class PeopleListItem extends StatelessWidget {
  final PeopleInfo peopleInfo;
  PeopleListItem(this.peopleInfo);

  @override
  Widget build(BuildContext context) {
    return PosterListItem(
        peopleInfo.profilePath,
        peopleInfo.name,
        null,
        null,
        peopleInfo.knownFor?.map((k) => k.title)?.toSet()?.toList()?.join(', '),
        () => MyNavigator.goToPersonInfo(context, peopleInfo.id));
  }
}

class TvListItem extends StatelessWidget {
  final TVInfo tvInfo;
  TvListItem(this.tvInfo);

  @override
  Widget build(BuildContext context) {
    return PosterListItem(tvInfo.posterPath, tvInfo.name, "Rating : ${tvInfo.voteAverage}/10 (${tvInfo.voteCount})",
        "Released on : " + tvInfo.firstAirDate, tvInfo.overview, () => MyNavigator.goToTVInfo(context, tvInfo.id));
  }
}

class PosterListItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String description;
  final Function callback;

  PosterListItem(this.imagePath, this.title, this.subtitle1, this.subtitle2, this.description, this.callback);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey),
        child: ListTile(
          onTap: callback,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: (imagePath == null)
              ? Icon(
                  Icons.movie_filter,
                  size: 80.0,
                )
              : CachedNetworkImage(
                  imageUrl: ImageUtils.getFullImagePath(imagePath),
                  placeholder: new CircularProgressIndicator(),
                  errorWidget: new Icon(Icons.error),
                  height: 80.0,
                ),
          title: CustomText(title, 18.0, true, Colors.white, 1),
          subtitle: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              subtitle1 == null ? Container() : CustomText(subtitle1, 12.0, false, Colors.white, 1),
              subtitle2 == null ? Container() : CustomText(subtitle2, 12.0, false, Colors.white, 1),
              Padding(padding: EdgeInsets.only(top: 5.0)),
              description == null ? new Container() : CustomText(description, 14.0, false, Colors.white, 2),
            ],
          ),
        ),
      ),
    );
  }
}

class FavMovieItem extends StatelessWidget {
  final MovieDetails movieDetails;
  FavMovieItem(this.movieDetails);

  @override
  Widget build(BuildContext context) {
    return PosterViewItem(
        movieDetails.posterPath,
        movieDetails.title,
        movieDetails.releaseDate,
        () => MyNavigator.goToMovieInfo(context, movieDetails.id),
        () => AppUtils.showConditionalAlert(context, 'Remove Bookmark?', null, "Yes", () {
              FireStoreManager.toggleMovieBookMark(movieDetails.id);
              Navigator.of(context).pop();
            }, "No", () => Navigator.of(context).pop()));
  }
}

class FavTvItem extends StatelessWidget {
  final TVDetails tvDetails;
  FavTvItem(this.tvDetails);

  @override
  Widget build(BuildContext context) {
    return PosterViewItem(
        tvDetails.posterPath,
        tvDetails.name,
        tvDetails.firstAirDate,
        () => MyNavigator.goToTVInfo(context, tvDetails.id),
        () => AppUtils.showConditionalAlert(context, 'Remove Bookmark?', null, "Yes", () {
              FireStoreManager.toggleTVBookMark(tvDetails.id);
              Navigator.of(context).pop();
            }, "No", () => Navigator.of(context).pop()));
  }
}

class FavPersonItem extends StatelessWidget {
  final PersonDetail personDetail;
  FavPersonItem(this.personDetail);

  @override
  Widget build(BuildContext context) {
    return PosterViewItem(
        personDetail.profilePath,
        personDetail.name,
        personDetail.knownForDepartment,
        () => MyNavigator.goToPersonInfo(context, personDetail.id),
        () => AppUtils.showConditionalAlert(context, 'Remove Bookmark?', null, "Yes", () {
              FireStoreManager.togglePersonBookMark(personDetail.id);
              Navigator.of(context).pop();
            }, "No", () => Navigator.of(context).pop()));
  }
}

class PersonCastItem extends StatelessWidget {
  final CastDetail castDetail;
  PersonCastItem(this.castDetail);

  @override
  Widget build(BuildContext context) {
    return PosterViewItem(castDetail.posterPath, castDetail.title, castDetail.character,
        () => MyNavigator.goToMovieInfo(context, castDetail.id), null);
  }
}

class PersonCrewItem extends StatelessWidget {
  final CrewDetail _crewDetail;
  PersonCrewItem(this._crewDetail);

  @override
  Widget build(BuildContext context) {
    return PosterViewItem(_crewDetail.posterPath, _crewDetail.title, _crewDetail.department,
        () => MyNavigator.goToMovieInfo(context, _crewDetail.id), null);
  }
}

class PersonTVCastItem extends StatelessWidget {
  final TvCast castDetail;
  PersonTVCastItem(this.castDetail);

  @override
  Widget build(BuildContext context) {
    return PosterViewItem(castDetail.posterPath, castDetail.name, castDetail.character,
        () => MyNavigator.goToTVInfo(context, castDetail.id), null);
  }
}

class PersonTVCrewItem extends StatelessWidget {
  final TvCrew _crewDetail;
  PersonTVCrewItem(this._crewDetail);

  @override
  Widget build(BuildContext context) {
    return PosterViewItem(_crewDetail.posterPath, _crewDetail.name, _crewDetail.department,
        () => MyNavigator.goToTVInfo(context, _crewDetail.id), null);
  }
}

class VideoItem extends StatelessWidget {
  final MovieVideo _video;
  VideoItem(this._video);

  @override
  Widget build(BuildContext context) {
    String imageUrl = "http://img.youtube.com/vi/${_video.key}/0.jpg";
    String youtubeUrl = "https://www.youtube.com/watch?v=${_video.key}";
    return Card(
      elevation: 4.0,
      child: Container(
        width: 200.0,
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        child: new GestureDetector(
          onTap: () => _launchYoutube(context, youtubeUrl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              (imageUrl == null)
                  ? Icon(
                      Icons.video_library,
                      color: Theme.of(context).primaryColor,
                      size: 120.0,
                    )
                  : CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: Icon(
                        Icons.video_library,
                        color: Theme.of(context).primaryColor,
                        size: 120.0,
                      ),
                      errorWidget: Icon(
                        Icons.error,
                        color: Theme.of(context).primaryColor,
                        size: 120.0,
                      ),
                      height: 150.0,
                    ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
              ),
              CenterText(_video.name, 14.0, true, Colors.white, 2),
              CenterText(_video.type, 14.0, true, Theme.of(context).primaryColor, 2),
            ],
          ),
        ),
      ),
    );
  }

  _launchYoutube(BuildContext context, String url) async {
    FlutterYoutube.playYoutubeVideoByUrl(apiKey: TMDB.youtubeAPIKey, videoUrl: url, autoPlay: true, fullScreen: false);
  }
}

class PosterViewItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle;
  final Function callback;
  final Function longPressCallBack;
  PosterViewItem(this.imagePath, this.title, this.subTitle, this.callback, this.longPressCallBack);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Container(
        width: 150.0,
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        child: new GestureDetector(
          onTap: callback,
          onLongPress: longPressCallBack,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              (imagePath == null)
                  ? Icon(
                      Icons.account_circle,
                      color: Theme.of(context).primaryColor,
                      size: 120.0,
                    )
                  : CachedNetworkImage(
                      imageUrl: ImageUtils.getFullImagePath(imagePath),
                      placeholder: Icon(
                        Icons.local_movies,
                        color: Theme.of(context).primaryColor,
                        size: 120.0,
                      ),
                      errorWidget: new Icon(Icons.error),
                      height: 120.0,
                    ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
              ),
              CenterText(title, 14.0, true, Colors.white, 2),
              CenterText(subTitle, 14.0, true, Theme.of(context).primaryColor, 2),
            ],
          ),
        ),
      ),
    );
  }
}
