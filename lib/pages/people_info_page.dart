import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_go/custom_views/custom_views.dart';
import 'package:movie_go/firestore/firestore_manager.dart';
import 'package:movie_go/models/people_info.dart';
import 'package:movie_go/models/person_images_response.dart';
import 'package:movie_go/tmdb.dart';
import 'package:movie_go/utils/image_util.dart';

class PeopleInfoPage extends StatefulWidget {
  final int peopleId;
  PeopleInfoPage(this.peopleId);

  @override
  State<StatefulWidget> createState() => PeopleInfoPageState(peopleId);
}

class PeopleInfoPageState extends State<PeopleInfoPage> {
  int peopleId;
  PeopleInfoPageState(this.peopleId);
  PersonDetail _personDetail;
  bool isBookmarked = false;
  String aliases;
  List<String> images;

  @override
  void initState() {
    super.initState();
    fetchPersonDetails();
    FireStoreManager.isPersonBookMarked(peopleId).then((marked) {
      isBookmarked = marked;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_personDetail?.name ?? "Loading..."),
        actions: <Widget>[
          IconButton(
            icon: Icon(isBookmarked ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              FireStoreManager.togglePersonBookMark(peopleId).then((_) {
                isBookmarked = !isBookmarked;
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: _personDetail == null
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
                              _personDetail.profilePath)),
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
                            CachedNetworkImage(
                              imageUrl: ImageUtils.getFullImagePath(
                                  _personDetail.profilePath),
                              placeholder: new CircularProgressIndicator(),
                              errorWidget: new Icon(Icons.person),
                              height: 200.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.0),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomText(_personDetail.name, 20.0, true,
                                      Colors.white, 2),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                  CustomText(
                                      "Department: ${_personDetail.knownForDepartment}",
                                      16.0,
                                      false,
                                      Colors.white,
                                      null),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                  CustomText(
                                      "Gender: ${_personDetail.gender == 2 ? "Male" : "Female"}",
                                      16.0,
                                      false,
                                      Colors.white,
                                      null),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                  CustomText("Born: ${_personDetail.birthday}",
                                      16.0, false, Colors.white, null),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                  CustomText(
                                      "Birth Place: ${_personDetail.placeOfBirth}",
                                      16.0,
                                      false,
                                      Colors.white,
                                      null),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                  ),
                                  _personDetail.deathday == null
                                      ? Container()
                                      : CustomText(
                                          "Death: ${_personDetail.birthday}",
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
                        _personDetail.alsoKnownAs == null ||
                                _personDetail.alsoKnownAs?.length == 0
                            ? Container()
                            : CustomText("Also knows as:\n\n$aliases", 16.0,
                                false, Colors.white, null),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                        ),
                        CustomText("Biography:\n\n${_personDetail.biography}",
                            16.0, false, Colors.white, null),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                        ),
                        CustomText("Images :", 20.0, true, Colors.white, null),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        Container(
                          height: 250.0,
                          child: (images == null || images?.length == 0)
                              ? Center(
                                  child: CenterText("No Images", 20.0, true,
                                      Theme.of(context).primaryColor, 1))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: images.length,
                                  itemBuilder: (ctxt, index) {
                                    return Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: CachedNetworkImage(
                                        imageUrl: ImageUtils.getFullImagePath(
                                            images[index]),
                                        placeholder:
                                            new CircularProgressIndicator(),
                                        errorWidget: new Icon(Icons.person),
                                        height: 200.0,
                                      ),
                                    );
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

  fetchPersonDetails() {
    HttpClient()
        .getUrl(Uri.parse("https://api.themoviedb"
            ".org/3/person/$peopleId?api_key=${TMDB.key}&language=en-US"))
        .then((request) => request.close()) // sends the request
        .then((response) {
      response.transform(utf8.decoder).join().then((detailsJson) {
        fetchImages();

        Map mapJson = json.decode(detailsJson);
        _personDetail = PersonDetail.fromJson(mapJson);
        aliases = _personDetail.alsoKnownAs?.join('\n');
        setState(() {});
      }).catchError((e) {
        print(e);
        setState(() {});
      });
    });
  }

  fetchImages() {
    HttpClient()
        .getUrl(Uri.parse("https://api.themoviedb"
            ".org/3/person/$peopleId/images?api_key=${TMDB.key}"))
        .then((request) => request.close()) // sends the request
        .then((response) {
      response.transform(utf8.decoder).join().then((detailsJson) {
        Map mapJson = json.decode(detailsJson);
        ImageResponse imageResponse = ImageResponse.fromJson(mapJson);
        images = imageResponse?.profiles?.map((i) => i.filePath)?.toList();
        setState(() {});
      }).catchError((e) {
        print(e);
        images = new List();
        setState(() {});
      });
    });
  }
}