class PeopleSearchData {
  int page;
  int totalResults;
  int totalPages;
  List<PeopleInfo> results;

  PeopleSearchData(
      {this.page, this.totalResults, this.totalPages, this.results});

  PeopleSearchData.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    totalResults = json['total_results'];
    totalPages = json['total_pages'];
    if (json['results'] != null) {
      results = new List<PeopleInfo>();
      json['results'].forEach((v) {
        results.add(new PeopleInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['total_results'] = this.totalResults;
    data['total_pages'] = this.totalPages;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PeopleInfo {
  double popularity;
  int id;
  String profilePath;
  String name;
  List<KnownFor> knownFor;
  bool adult;

  PeopleInfo(
      {this.popularity,
      this.id,
      this.profilePath,
      this.name,
      this.knownFor,
      this.adult});

  PeopleInfo.fromJson(Map<String, dynamic> json) {
    popularity = json['popularity'].toDouble();
    id = json['id'];
    profilePath = json['profile_path'];
    name = json['name'];
    if (json['known_for'] != null) {
      knownFor = new List<KnownFor>();
      json['known_for'].forEach((v) {
        knownFor.add(new KnownFor.fromJson(v));
      });
    }
    adult = json['adult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['popularity'] = this.popularity;
    data['id'] = this.id;
    data['profile_path'] = this.profilePath;
    data['name'] = this.name;
    if (this.knownFor != null) {
      data['known_for'] = this.knownFor.map((v) => v.toJson()).toList();
    }
    data['adult'] = this.adult;
    return data;
  }
}

class KnownFor {
  double voteAverage;
  int voteCount;
  int id;
  bool video;
  String mediaType;
  String title;
  double popularity;
  String posterPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String backdropPath;
  bool adult;
  String overview;
  String releaseDate;

  KnownFor(
      {this.voteAverage,
      this.voteCount,
      this.id,
      this.video,
      this.mediaType,
      this.title,
      this.popularity,
      this.posterPath,
      this.originalLanguage,
      this.originalTitle,
      this.genreIds,
      this.backdropPath,
      this.adult,
      this.overview,
      this.releaseDate});

  KnownFor.fromJson(Map<String, dynamic> json) {
    voteAverage = json['vote_average'].toDouble();
    voteCount = json['vote_count'];
    id = json['id'];
    video = json['video'];
    mediaType = json['media_type'];
    title = json['title'];
    popularity = json['popularity'].toDouble();
    posterPath = json['poster_path'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    genreIds = json['genre_ids'].cast<int>();
    backdropPath = json['backdrop_path'];
    adult = json['adult'];
    overview = json['overview'];
    releaseDate = json['release_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    data['id'] = this.id;
    data['video'] = this.video;
    data['media_type'] = this.mediaType;
    data['title'] = this.title;
    data['popularity'] = this.popularity;
    data['poster_path'] = this.posterPath;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['genre_ids'] = this.genreIds;
    data['backdrop_path'] = this.backdropPath;
    data['adult'] = this.adult;
    data['overview'] = this.overview;
    data['release_date'] = this.releaseDate;
    return data;
  }
}
