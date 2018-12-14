import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_go/models/movie_search_model.dart';
import 'package:movie_go/utils/image_util.dart';

class MovieInfoPage extends StatefulWidget {
  MovieInfo movieInfo;
  MovieInfoPage(this.movieInfo);

  @override
  State<StatefulWidget> createState() => MovieInfoPageState(movieInfo);
}

class MovieInfoPageState extends State<MovieInfoPage> {
  MovieInfo movieInfo;
  MovieInfoPageState(this.movieInfo);

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
                    ImageUtils.GetFullImagePath(movieInfo.backdropPath)),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.black54),
          )
        ],
      ),
    );
  }
}
