import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:movie_go/models/movie_details.dart';
import 'package:movie_go/models/movie_search_model.dart';
import 'package:movie_go/models/people_info.dart';
import 'package:movie_go/utils/image_util.dart';
import 'package:movie_go/utils/navigator_util.dart';

class MovieListItem extends StatelessWidget {
  final MovieInfo movieInfo;
  MovieListItem(this.movieInfo);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey),
        child: ListTile(
          onTap: () => MyNavigator.goToMovieInfo(context, movieInfo.id),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: (movieInfo.posterPath == null)
              ? Icon(
                  Icons.movie_filter,
                  size: 80.0,
                )
              : CachedNetworkImage(
                  imageUrl: ImageUtils.getFullImagePath(movieInfo.posterPath),
                  placeholder: new CircularProgressIndicator(),
                  errorWidget: new Icon(Icons.error),
                  height: 80.0,
                ),
          title: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                movieInfo.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                maxLines: 1,
              ),
              Text(
                "Rating : " +
                    movieInfo.voteAverage.toString() +
                    "/10 (" +
                    movieInfo.voteCount.toString() +
                    ")",
                style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 12.0,
                ),
                maxLines: 1,
              ),
            ],
          ),
          subtitle: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              movieInfo.overview == null
                  ? new Container()
                  : Text(
                      movieInfo.overview,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
              Padding(padding: EdgeInsets.only(top: 5.0)),
              Text(
                "Released on : " + movieInfo.releaseDate,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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
        () => MyNavigator.goToMovieInfo(context, movieDetails.id));
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
        () => MyNavigator.goToPersonInfo(context, personDetail.id));
  }
}

class PersonCastItem extends StatelessWidget {
  final CastDetail castDetail;
  PersonCastItem(this.castDetail);

  @override
  Widget build(BuildContext context) {
    return PosterViewItem(
        castDetail.posterPath,
        castDetail.title,
        castDetail.character,
        () => MyNavigator.goToMovieInfo(context, castDetail.id));
  }
}

class PersonCrewItem extends StatelessWidget {
  final CrewDetail _crewDetail;
  PersonCrewItem(this._crewDetail);

  @override
  Widget build(BuildContext context) {
    return PosterViewItem(
        _crewDetail.posterPath,
        _crewDetail.title,
        _crewDetail.department,
        () => MyNavigator.goToMovieInfo(context, _crewDetail.id));
  }
}

class PosterViewItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle;
  final Function callback;
  PosterViewItem(this.imagePath, this.title, this.subTitle, this.callback);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Container(
        width: 150.0,
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        child: new GestureDetector(
          onTap: callback,
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
              CenterText(
                  subTitle, 14.0, true, Theme.of(context).primaryColor, 2),
            ],
          ),
        ),
      ),
    );
  }
}
