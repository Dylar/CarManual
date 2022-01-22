class CarInfo {
  static const FIELD_SELLER = "seller";
  static const FIELD_NAME = "name";
  static const FIELD_PIC_URL = "pic_url";
  static const FIELD_VID_URL = "vid_url";

  const CarInfo(this.seller, this.name, this.picUrl, this.vidUrl);

  final String seller, name, picUrl, vidUrl;

  static CarInfo fromMap(Map<String, dynamic> map) => CarInfo(
        map[FIELD_SELLER] ?? "Unbekannt",
        map[FIELD_NAME] ?? "Unbekannt",
        map[FIELD_PIC_URL] ?? "",
        map[FIELD_VID_URL] ?? "",
      );
}
