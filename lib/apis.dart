import 'dart:convert';
import 'dart:io';

import 'package:movie_go/tmdb.dart';

class MovieAPI {
  static void fetchMovieList(
      String searchText, int pageNumber, Function result, Function error) {
    HttpClient()
        .getUrl(Uri.parse("https://api.themoviedb.org/3/search/movie?api_key=" +
            TMDB.key +
            "&language=en-US&query=$searchText&page=$pageNumber&include_adult=false")) // produces a request object
        .then((request) => request.close()) // sends the request
        .then((response) {
      response.transform(utf8.decoder).join().then((jsonString) {
        Map mapJson = json.decode(jsonString);
        result(mapJson);
      }).catchError((e) {
        print(e);
        error(e);
      });
    });
  }
}
