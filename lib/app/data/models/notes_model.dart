class Notes {
  int? id;
  String? userUid;
  String? title;
  String? description;
  String? createdAt;

  Notes({this.id, this.userUid, this.title, this.description, this.createdAt});

  Notes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userUid = json['user_uid'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
  }

  Notes.fromDynamic(dynamic json) {
    id = json['id'];
    userUid = json['user_uid'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_uid'] = userUid;
    data['title'] = title;
    data['description'] = description;
    data['created_at'] = createdAt;
    return data;
  }

  static List<Notes> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => Notes.fromJson(e)).toList();
  }

  static List<Notes> fromDynamicList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => Notes.fromDynamic(e)).toList();
  }
}
