class Cast {
  List<CastP> cast = new List();

  Cast.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((item) {
      final castP = CastP.fromJsonMap(item);
      cast.add(castP);
    });
  }
}

class CastP {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  CastP({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  CastP.fromJsonMap(Map<String, dynamic> json) {
    castId = json['cast_id'];
    character = json['character'];
    creditId = json['credit_id'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    order = json['order'];
    profilePath = json['profile_path'];
  }
  getPhoto() {
    if (profilePath == null) {
      return 'https://www.publicdomainpictures.net/pictures/280000/velka/not-found-image-15383864787lu.jpg';
    }
    return "https://image.tmdb.org/t/p/w500/$profilePath";
  }
}
