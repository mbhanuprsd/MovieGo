class PeopleTvCredits {
  List<TvCast> cast;
  List<TvCrew> crew;
  int id;

  PeopleTvCredits({this.cast, this.crew, this.id});

  PeopleTvCredits.fromJson(Map<String, dynamic> json) {
    if (json['cast'] != null) {
      cast = new List<TvCast>();
      json['cast'].forEach((v) {
        cast.add(new TvCast.fromJson(v));
      });
    }
    if (json['crew'] != null) {
      crew = new List<TvCrew>();
      json['crew'].forEach((v) {
        crew.add(new TvCrew.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cast != null) {
      data['cast'] = this.cast.map((v) => v.toJson()).toList();
    }
    if (this.crew != null) {
      data['crew'] = this.crew.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

class TvCast {
  String creditId;
  String originalName;
  int id;
  List<int> genreIds;
  String character;
  String name;
  String posterPath;
  int voteCount;
  double voteAverage;
  double popularity;
  int episodeCount;
  String originalLanguage;
  String firstAirDate;
  String backdropPath;
  String overview;
  List<String> originCountry;

  TvCast(
      {this.creditId,
      this.originalName,
      this.id,
      this.genreIds,
      this.character,
      this.name,
      this.posterPath,
      this.voteCount,
      this.voteAverage,
      this.popularity,
      this.episodeCount,
      this.originalLanguage,
      this.firstAirDate,
      this.backdropPath,
      this.overview,
      this.originCountry});

  TvCast.fromJson(Map<String, dynamic> json) {
    creditId = json['credit_id'];
    originalName = json['original_name'];
    id = json['id'];
    genreIds = json['genre_ids'].cast<int>();
    character = json['character'];
    name = json['name'];
    posterPath = json['poster_path'];
    voteCount = json['vote_count'];
    voteAverage = json['vote_average'].toDouble();
    popularity = json['popularity'].toDouble();
    episodeCount = json['episode_count'];
    originalLanguage = json['original_language'];
    firstAirDate = json['first_air_date'];
    backdropPath = json['backdrop_path'];
    overview = json['overview'];
    originCountry = json['origin_country'].cast<String>();

    try {
      DateTime.parse(firstAirDate);
    } catch (e) {
      firstAirDate = "0000-00-00";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['credit_id'] = this.creditId;
    data['original_name'] = this.originalName;
    data['id'] = this.id;
    data['genre_ids'] = this.genreIds;
    data['character'] = this.character;
    data['name'] = this.name;
    data['poster_path'] = this.posterPath;
    data['vote_count'] = this.voteCount;
    data['vote_average'] = this.voteAverage;
    data['popularity'] = this.popularity;
    data['episode_count'] = this.episodeCount;
    data['original_language'] = this.originalLanguage;
    data['first_air_date'] = this.firstAirDate;
    data['backdrop_path'] = this.backdropPath;
    data['overview'] = this.overview;
    data['origin_country'] = this.originCountry;
    return data;
  }
}

class TvCrew {
  int id;
  String department;
  String originalLanguage;
  int episodeCount;
  String job;
  String overview;
  List<String> originCountry;
  String originalName;
  List<int> genreIds;
  String name;
  String firstAirDate;
  String backdropPath;
  double popularity;
  int voteCount;
  double voteAverage;
  String posterPath;
  String creditId;

  TvCrew(
      {this.id,
      this.department,
      this.originalLanguage,
      this.episodeCount,
      this.job,
      this.overview,
      this.originCountry,
      this.originalName,
      this.genreIds,
      this.name,
      this.firstAirDate,
      this.backdropPath,
      this.popularity,
      this.voteCount,
      this.voteAverage,
      this.posterPath,
      this.creditId});

  TvCrew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    department = json['department'];
    originalLanguage = json['original_language'];
    episodeCount = json['episode_count'];
    job = json['job'];
    overview = json['overview'];
    originCountry = json['origin_country'].cast<String>();
    originalName = json['original_name'];
    genreIds = json['genre_ids'].cast<int>();
    name = json['name'];
    firstAirDate = json['first_air_date'];
    backdropPath = json['backdrop_path'];
    popularity = json['popularity'].toDouble();
    voteCount = json['vote_count'];
    voteAverage = json['vote_average'].toDouble();
    posterPath = json['poster_path'];
    creditId = json['credit_id'];
    try {
      DateTime.parse(firstAirDate);
    } catch (e) {
      firstAirDate = "0000-00-00";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['department'] = this.department;
    data['original_language'] = this.originalLanguage;
    data['episode_count'] = this.episodeCount;
    data['job'] = this.job;
    data['overview'] = this.overview;
    data['origin_country'] = this.originCountry;
    data['original_name'] = this.originalName;
    data['genre_ids'] = this.genreIds;
    data['name'] = this.name;
    data['first_air_date'] = this.firstAirDate;
    data['backdrop_path'] = this.backdropPath;
    data['popularity'] = this.popularity;
    data['vote_count'] = this.voteCount;
    data['vote_average'] = this.voteAverage;
    data['poster_path'] = this.posterPath;
    data['credit_id'] = this.creditId;
    return data;
  }
}
