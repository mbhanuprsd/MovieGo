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
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey),
        child: ListTile(
          onTap: () {},
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: (castInfo.profilePath == null)
              ? Icon(
                  Icons.account_circle,
                  size: imageHeight,
                )
              : CachedNetworkImage(
                  imageUrl: ImageUtils.getFullImagePath(castInfo.profilePath),
                  placeholder: new CircularProgressIndicator(),
                  errorWidget: new Icon(Icons.error),
                  height: imageHeight,
                ),
          title: CustomText(castInfo.name, 16.0, true, Colors.white, 2),
          subtitle: CustomText(castInfo.character, 14.0, false,
              Theme.of(context).primaryColor, 2),
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
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey),
        child: ListTile(
          onTap: () {},
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              (crewInfo.profilePath == null)
                  ? Icon(
                      Icons.account_circle,
                      size: imageHeight,
                    )
                  : CachedNetworkImage(
                      imageUrl:
                          ImageUtils.getFullImagePath(crewInfo.profilePath),
                      placeholder: new CircularProgressIndicator(),
                      errorWidget: new Icon(Icons.error),
                      height: imageHeight,
                    ),
              CustomText(crewInfo.name, 16.0, true, Colors.white, 2),
            ],
          ),
          subtitle: CustomText(
              crewInfo.job, 14.0, false, Theme.of(context).primaryColor, 2),
        ),
      ),
    );
  }
}
