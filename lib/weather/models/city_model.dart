class City {
  final String name;
  final String id;

  City(this.name, this.id);

  factory City.fromJson(Map<String, dynamic> json) {
    return City(json['title'], json['woeid'].toString());
  }
}
