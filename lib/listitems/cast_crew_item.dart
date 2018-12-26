import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:movie_go/models/cast_crew_details.dart';
import 'package:movie_go/utils/image_util.dart';
import 'package:movie_go/utils/navigator_util.dart';

double imageHeight = 150.0;

class CastItem extends StatelessWidget {
  final Cast castInfo;
  CastItem(this.castInfo);

  @override
  Widget build(BuildContext context) {
    print("${castInfo.name}: ${castInfo.id}\n");
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
            GestureDetector(
              child: (castInfo.profilePath == null)
                  ? Icon(
                      Icons.account_circle,
                      color: Theme.of(context).primaryColor,
                      size: 120.0,
                    )
                  : CachedNetworkImage(
                      imageUrl:
                          ImageUtils.getFullImagePath(castInfo.profilePath),
                      placeholder: Icon(
                        Icons.account_circle,
                        color: Theme.of(context).primaryColor,
                        size: 120.0,
                      ),
                      errorWidget: new Icon(Icons.error),
                      height: 120.0,
                    ),
              onTap: () => MyNavigator.goToPersonInfo(context, castInfo.id),
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
            GestureDetector(
              child: (crewInfo.profilePath == null)
                  ? Icon(
                      Icons.account_circle,
                      color: Theme.of(context).primaryColor,
                      size: 120.0,
                    )
                  : CachedNetworkImage(
                      imageUrl:
                          ImageUtils.getFullImagePath(crewInfo.profilePath),
                      placeholder: Icon(
                        Icons.account_circle,
                        color: Theme.of(context).primaryColor,
                        size: 120.0,
                      ),
                      errorWidget: new Icon(Icons.error),
                      height: 120.0,
                    ),
              onTap: () => MyNavigator.goToPersonInfo(context, crewInfo.id),
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
