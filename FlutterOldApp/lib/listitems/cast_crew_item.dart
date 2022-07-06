import 'package:flutter/material.dart';
import 'package:movie_go/listitems/movie_item.dart';
import 'package:movie_go/models/cast_crew_details.dart';
import 'package:movie_go/utils/navigator_util.dart';

double imageHeight = 150.0;

class CastItem extends StatelessWidget {
  final Cast castInfo;
  CastItem(this.castInfo);

  @override
  Widget build(BuildContext context) {
    print("${castInfo.name}: ${castInfo.id}\n");
    return PosterViewItem(
        castInfo.profilePath,
        castInfo.name,
        castInfo.character,
        () => MyNavigator.goToPersonInfo(context, castInfo.id),
        null);
  }
}

class CrewItem extends StatelessWidget {
  final Crew crewInfo;
  CrewItem(this.crewInfo);

  @override
  Widget build(BuildContext context) {
    return PosterViewItem(crewInfo.profilePath, crewInfo.name, crewInfo.job,
        () => MyNavigator.goToPersonInfo(context, crewInfo.id), null);
  }
}
