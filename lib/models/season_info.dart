class SeasonInfo {
  String sId;
  String airDate;
  List<Episodes> episodes;
  String name;
  String overview;
  int id;
  String posterPath;
  int seasonNumber;

  SeasonInfo(
      {this.sId, this.airDate, this.episodes, this.name, this.overview, this.id, this.posterPath, this.seasonNumber});

  SeasonInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    airDate = json['air_date'];
    if (json['episodes'] != null) {
      episodes = new List<Episodes>();
      json['episodes'].forEach((v) {
        episodes.add(new Episodes.fromJson(v));
      });
    }
    name = json['name'];
    overview = json['overview'];
    id = json['id'];
    posterPath = json['poster_path'];
    seasonNumber = json['season_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['air_date'] = this.airDate;
    if (this.episodes != null) {
      data['episodes'] = this.episodes.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['overview'] = this.overview;
    data['id'] = this.id;
    data['poster_path'] = this.posterPath;
    data['season_number'] = this.seasonNumber;
    return data;
  }
}

class Episodes {
  String airDate;
  List<SeasonCrew> crew;
  int episodeNumber;
  List<GuestStars> guestStars;
  String name;
  String overview;
  int id;
  String productionCode;
  int seasonNumber;
  String stillPath;
  double voteAverage;
  int voteCount;

  Episodes(
      {this.airDate,
      this.crew,
      this.episodeNumber,
      this.guestStars,
      this.name,
      this.overview,
      this.id,
      this.productionCode,
      this.seasonNumber,
      this.stillPath,
      this.voteAverage,
      this.voteCount});

  Episodes.fromJson(Map<String, dynamic> json) {
    airDate = json['air_date'];
    if (json['crew'] != null) {
      crew = new List<SeasonCrew>();
      json['crew'].forEach((v) {
        crew.add(new SeasonCrew.fromJson(v));
      });
    }
    episodeNumber = json['episode_number'];
    if (json['guest_stars'] != null) {
      guestStars = new List<GuestStars>();
      json['guest_stars'].forEach((v) {
        guestStars.add(new GuestStars.fromJson(v));
      });
    }
    name = json['name'];
    overview = json['overview'];
    id = json['id'];
    productionCode = json['production_code'];
    seasonNumber = json['season_number'];
    stillPath = json['still_path'];
    voteAverage = json['vote_average'].toDouble();
    voteCount = json['vote_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['air_date'] = this.airDate;
    if (this.crew != null) {
      data['crew'] = this.crew.map((v) => v.toJson()).toList();
    }
    data['episode_number'] = this.episodeNumber;
    if (this.guestStars != null) {
      data['guest_stars'] = this.guestStars.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['overview'] = this.overview;
    data['id'] = this.id;
    data['production_code'] = this.productionCode;
    data['season_number'] = this.seasonNumber;
    data['still_path'] = this.stillPath;
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    return data;
  }
}

class SeasonCrew {
  int id;
  String creditId;
  String name;
  String department;
  String job;
  String profilePath;

  SeasonCrew({this.id, this.creditId, this.name, this.department, this.job, this.profilePath});

  SeasonCrew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creditId = json['credit_id'];
    name = json['name'];
    department = json['department'];
    job = json['job'];
    profilePath = json['profile_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['credit_id'] = this.creditId;
    data['name'] = this.name;
    data['department'] = this.department;
    data['job'] = this.job;
    data['profile_path'] = this.profilePath;
    return data;
  }
}

class GuestStars {
  int id;
  String name;
  String creditId;
  String character;
  int order;
  String profilePath;

  GuestStars({this.id, this.name, this.creditId, this.character, this.order, this.profilePath});

  GuestStars.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    creditId = json['credit_id'];
    character = json['character'];
    order = json['order'];
    profilePath = json['profile_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['credit_id'] = this.creditId;
    data['character'] = this.character;
    data['order'] = this.order;
    data['profile_path'] = this.profilePath;
    return data;
  }
}
