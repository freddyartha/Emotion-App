import 'package:emotion_app/app/mahas/services/mahas_format.dart';

class EmotionsModel {
  int? id;
  String? userUid;
  String? emotionTitle;
  String? emotionDesc;
  String? images;
  DateTime? dateCreated;
  DateTime? updatedAt;
  String? timeCreated;
  int? emotionId;
  OneEmotion? oneEmotion;
  List<EmotionslistExecutant>? emotionslistExecutant;

  EmotionsModel(
      {this.id,
      this.userUid,
      this.emotionTitle,
      this.emotionDesc,
      this.images,
      this.dateCreated,
      this.updatedAt,
      this.timeCreated,
      this.emotionId,
      this.oneEmotion,
      this.emotionslistExecutant});

  EmotionsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userUid = json['user_uid'];
    emotionTitle = json['emotion_title'];
    emotionDesc = json['emotion_desc'];
    images = json['images'];
    dateCreated = MahasFormat.dynamicToDateTime(json['date_created']);
    updatedAt = MahasFormat.dynamicToDateTime(json['updated_at']);
    timeCreated = json['time_created'];
    emotionId = json['emotion_id'];
    oneEmotion = json['one_emotion'] != null
        ? OneEmotion.fromJson(json['one_emotion'])
        : null;
    if (json['emotionslist_executant'] != null) {
      emotionslistExecutant = <EmotionslistExecutant>[];
      json['emotionslist_executant'].forEach((v) {
        emotionslistExecutant!.add(EmotionslistExecutant.fromJson(v));
      });
    }
  }

  static List<EmotionsModel> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => EmotionsModel.fromJson(e)).toList();
  }

  // static List<EmotionsModel> fromDynamicList(List? data) {
  //   if (data == null || data.isEmpty) return [];
  //   return data.map((e) => EmotionsModel.fromDynamic(e)).toList();
  // }
}

class OneEmotion {
  String? description;

  OneEmotion({this.description});

  OneEmotion.fromJson(Map<String, dynamic> json) {
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    return data;
  }
}

class EmotionslistExecutant {
  Executant? executant;

  EmotionslistExecutant({this.executant});

  EmotionslistExecutant.fromJson(Map<String, dynamic> json) {
    executant = json['executant'] != null
        ? Executant.fromJson(json['executant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (executant != null) {
      data['executant'] = executant!.toJson();
    }
    return data;
  }
}

class Executant {
  String? name;

  Executant({this.name});

  Executant.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
