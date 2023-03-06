import 'dart:convert';
import '../../mahas/services/mahas_format.dart';

class ExecutantModel {
  int? id;
  String? name;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? userUid;
  String? image;

  ExecutantModel();

  static ExecutantModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static ExecutantModel fromDynamic(dynamic dynamicData) {
    final model = ExecutantModel();

    model.id = MahasFormat.dynamicToInt(dynamicData['id']);
    model.name = dynamicData['name'];
    model.description = dynamicData['description'];
    model.createdAt = MahasFormat.dynamicToDateTime(dynamicData['created_at']);
    model.updatedAt = MahasFormat.dynamicToDateTime(dynamicData['updated_at']);
    model.userUid = dynamicData['user_uid'];
    model.image = dynamicData['image'];

    return model;
  }

  static List<ExecutantModel> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => ExecutantModel.fromJson(e)).toList();
  }

  static List<ExecutantModel> fromDynamicList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => ExecutantModel.fromDynamic(e)).toList();
  }
}
