class PersonDetail {
  String birthday;
  String knownForDepartment;
  String deathday;
  int id;
  String name;
  List<String> alsoKnownAs;
  int gender;
  String biography;
  double popularity;
  String placeOfBirth;
  String profilePath;
  bool adult;
  String imdbId;
  String homepage;

  PersonDetail(
      {this.birthday,
      this.knownForDepartment,
      this.deathday,
      this.id,
      this.name,
      this.alsoKnownAs,
      this.gender,
      this.biography,
      this.popularity,
      this.placeOfBirth,
      this.profilePath,
      this.adult,
      this.imdbId,
      this.homepage});

  PersonDetail.fromJson(Map<String, dynamic> json) {
    birthday = json['birthday'];
    knownForDepartment = json['known_for_department'];
    deathday = json['deathday'];
    id = json['id'];
    name = json['name'];
    alsoKnownAs = json['also_known_as'].cast<String>();
    gender = json['gender'];
    biography = json['biography'];
    popularity = json['popularity'];
    placeOfBirth = json['place_of_birth'];
    profilePath = json['profile_path'];
    adult = json['adult'];
    imdbId = json['imdb_id'];
    homepage = json['homepage'];

    try {
      DateTime.parse(birthday);
    } catch (e) {
      birthday = "0000-00-00";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['birthday'] = this.birthday;
    data['known_for_department'] = this.knownForDepartment;
    data['deathday'] = this.deathday;
    data['id'] = this.id;
    data['name'] = this.name;
    data['also_known_as'] = this.alsoKnownAs;
    data['gender'] = this.gender;
    data['biography'] = this.biography;
    data['popularity'] = this.popularity;
    data['place_of_birth'] = this.placeOfBirth;
    data['profile_path'] = this.profilePath;
    data['adult'] = this.adult;
    data['imdb_id'] = this.imdbId;
    data['homepage'] = this.homepage;
    return data;
  }
}

class MovieCredits {
  List<CastDetail> cast;
  List<CrewDetail> crew;
  int id;

  MovieCredits({this.cast, this.crew, this.id});

  MovieCredits.fromJson(Map<String, dynamic> json) {
    if (json['cast'] != null) {
      cast = new List<CastDetail>();
      json['cast'].forEach((v) {
        cast.add(new CastDetail.fromJson(v));
      });
    }
    if (json['crew'] != null) {
      crew = new List<CrewDetail>();
      json['crew'].forEach((v) {
        crew.add(new CrewDetail.fromJson(v));
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

class CastDetail {
  String character;
  String creditId;
  String releaseDate;
  int voteCount;
  bool video;
  bool adult;
  double voteAverage;
  String title;
  List<int> genreIds;
  String originalLanguage;
  String originalTitle;
  double popularity;
  int id;
  String backdropPath;
  String overview;
  String posterPath;

  CastDetail(
      {this.character,
      this.creditId,
      this.releaseDate,
      this.voteCount,
      this.video,
      this.adult,
      this.voteAverage,
      this.title,
      this.genreIds,
      this.originalLanguage,
      this.originalTitle,
      this.popularity,
      this.id,
      this.backdropPath,
      this.overview,
      this.posterPath});

  CastDetail.fromJson(Map<String, dynamic> json) {
    character = json['character'];
    creditId = json['credit_id'];
    releaseDate = json['release_date'];
    voteCount = json['vote_count'];
    video = json['video'];
    adult = json['adult'];
    voteAverage = json['vote_average'].toDouble();
    title = json['title'];
    genreIds = json['genre_ids'].cast<int>();
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    popularity = json['popularity'].toDouble();
    id = json['id'];
    backdropPath = json['backdrop_path'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    try {
      DateTime.parse(releaseDate);
    } catch (e) {
      releaseDate = "0000-00-00";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['character'] = this.character;
    data['credit_id'] = this.creditId;
    data['release_date'] = this.releaseDate;
    data['vote_count'] = this.voteCount;
    data['video'] = this.video;
    data['adult'] = this.adult;
    data['vote_average'] = this.voteAverage;
    data['title'] = this.title;
    data['genre_ids'] = this.genreIds;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['popularity'] = this.popularity;
    data['id'] = this.id;
    data['backdrop_path'] = this.backdropPath;
    data['overview'] = this.overview;
    data['poster_path'] = this.posterPath;
    return data;
  }
}

class CrewDetail {
  int id;
  String department;
  String originalLanguage;
  String originalTitle;
  String job;
  String overview;
  int voteCount;
  bool video;
  String releaseDate;
  double voteAverage;
  String title;
  double popularity;
  List<int> genreIds;
  String backdropPath;
  bool adult;
  String posterPath;
  String creditId;

  CrewDetail(
      {this.id,
      this.department,
      this.originalLanguage,
      this.originalTitle,
      this.job,
      this.overview,
      this.voteCount,
      this.video,
      this.releaseDate,
      this.voteAverage,
      this.title,
      this.popularity,
      this.genreIds,
      this.backdropPath,
      this.adult,
      this.posterPath,
      this.creditId});

  CrewDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    department = json['department'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    job = json['job'];
    overview = json['overview'];
    voteCount = json['vote_count'];
    video = json['video'];
    releaseDate = json['release_date'];
    voteAverage = json['vote_average'].toDouble();
    title = json['title'];
    popularity = json['popularity'].toDouble();
    genreIds = json['genre_ids'].cast<int>();
    backdropPath = json['backdrop_path'];
    adult = json['adult'];
    posterPath = json['poster_path'];
    creditId = json['credit_id'];
    try {
      DateTime.parse(releaseDate);
    } catch (e) {
      releaseDate = "0000-00-00";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['department'] = this.department;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['job'] = this.job;
    data['overview'] = this.overview;
    data['vote_count'] = this.voteCount;
    data['video'] = this.video;
    data['release_date'] = this.releaseDate;
    data['vote_average'] = this.voteAverage;
    data['title'] = this.title;
    data['popularity'] = this.popularity;
    data['genre_ids'] = this.genreIds;
    data['backdrop_path'] = this.backdropPath;
    data['adult'] = this.adult;
    data['poster_path'] = this.posterPath;
    data['credit_id'] = this.creditId;
    return data;
  }
}
