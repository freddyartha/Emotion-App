class VersionsModel {
  int? id;
  String? iosVersion;
  String? androidVersion;
  String? linkAppstore;
  String? linkPlaystore;

  VersionsModel();

  VersionsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iosVersion = json['ios_version'];
    androidVersion = json['android_version'];
    linkAppstore = json['link_appstore'];
    linkPlaystore = json['link_playstore'];
  }

  Map<String, dynamic> versionsListtoMap() {
    return {
      'id': id,
      'ios_version': iosVersion,
      'android_version': androidVersion,
      'link_appstore': linkAppstore,
      'link_playstore': linkPlaystore,
    };
  }

  static List<VersionsModel> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => VersionsModel.fromJson(e)).toList();
  }
}
