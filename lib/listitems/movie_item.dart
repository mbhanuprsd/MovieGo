import 'package:flutter/material.dart';
import 'package:movie_go/models/movie_search_model.dart';
import 'package:movie_go/utils/image_util.dart';
import 'package:movie_go/utils/navigator_util.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
          onTap: () => MyNavigator.goToMovieInfo(context, movieInfo),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: (movieInfo.posterPath == null)
              ? Icon(
                  Icons.movie_filter,
                  size: 80.0,
                )
              : CachedNetworkImage(
                  imageUrl: ImageUtils.GetFullImagePath(movieInfo.posterPath),
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
