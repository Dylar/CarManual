class CarInfo {
  const CarInfo(this.seller, this.name, this.url);

  final String seller, name, url;

  static CarInfo fromJson(Map<String, dynamic> map) {
    return CarInfo(map["seller"], map["name"], map["url"]);
  }
}
