import 'dart:convert';
import '../../mahas/services/mahas_format.dart';

class OneemotionModel {
  int? id;
  String? image;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? userUid;

  OneemotionModel();

  static OneemotionModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static OneemotionModel fromDynamic(dynamic dynamicData) {
    final model = OneemotionModel();

    model.id = MahasFormat.dynamicToInt(dynamicData['id']);
    model.image = dynamicData['image'];
    model.description = dynamicData['description'];
    model.createdAt = MahasFormat.dynamicToDateTime(dynamicData['created_at']);
    model.updatedAt = MahasFormat.dynamicToDateTime(dynamicData['updated_at']);
    model.userUid = dynamicData['user_uid'];

    return model;
  }

  Map<String, dynamic> oneEmotiontoMap() {
    return {
      'id': id,
      'image': image,
      'description': description,
      'created_at': MahasFormat.dateToString(createdAt),
      'updated_at': MahasFormat.dateToString(updatedAt),
      'user_uid': userUid
    };
  }

  static List<OneemotionModel> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => OneemotionModel.fromJson(e)).toList();
  }

  static List<OneemotionModel> fromDynamicList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => OneemotionModel.fromDynamic(e)).toList();
  }
}
