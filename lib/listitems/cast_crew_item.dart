import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:movie_go/models/cast_crew_details.dart';
import 'package:movie_go/utils/image_util.dart';
import 'package:cached_network_image/cached_network_image.dart';

double imageHeight = 150.0;

class CastItem extends StatelessWidget {
  final Cast castInfo;
  CastItem(this.castInfo);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
      child: Container(
        width: 150.0,
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            (castInfo.profilePath == null)
                ? Icon(
                    Icons.account_circle,
                    size: 120.0,
                  )
                : CachedNetworkImage(
                    imageUrl: ImageUtils.getFullImagePath(castInfo.profilePath),
                    placeholder: new CircularProgressIndicator(),
                    errorWidget: new Icon(Icons.error),
                    height: 120.0,
                  ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            CenterText(castInfo.name, 16.0, true, Colors.white, 2),
            CenterText(castInfo.character, 14.0, true,
                Theme.of(context).primaryColor, 2),
          ],
        ),
      ),
    );
  }
}

class CrewItem extends StatelessWidget {
  final Crew crewInfo;
  CrewItem(this.crewInfo);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
      child: Container(
        width: 150.0,
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            (crewInfo.profilePath == null)
                ? Icon(
                    Icons.account_circle,
                    size: 120.0,
                  )
                : CachedNetworkImage(
                    imageUrl: ImageUtils.getFullImagePath(crewInfo.profilePath),
                    placeholder: new CircularProgressIndicator(),
                    errorWidget: new Icon(Icons.error),
                    height: 120.0,
                  ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            CenterText(crewInfo.name, 16.0, true, Colors.white, 2),
            CenterText(
                crewInfo.job, 14.0, true, Theme.of(context).primaryColor, 2),
          ],
        ),
      ),
    );
  }
}
