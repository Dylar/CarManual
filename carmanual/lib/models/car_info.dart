class CarInfo {
  static const FIELD_SELLER = "seller";
  static const FIELD_NAME = "name";
  static const FIELD_URL = "url";

  const CarInfo(this.seller, this.name, this.url);

  final String seller, name, url;

  static CarInfo fromMap(Map<String, dynamic> map) => CarInfo(
        map[FIELD_SELLER],
        map[FIELD_NAME],
        map[FIELD_URL],
      );
}
