import '../../mahas/services/mahas_format.dart';

class Users {
  int? id;
  String? userUid;
  String? name;
  String? address;
  String? sex;
  DateTime? birthDate;
  String? email;
  DateTime? createdAt;
  String? profilePic;

  Users(
      {this.id,
      this.userUid,
      this.name,
      this.address,
      this.sex,
      this.birthDate,
      this.email,
      this.createdAt,
      this.profilePic});

  Users.fromDynamic(dynamic json) {
    id = json['id'];
    userUid = json['user_uid'];
    name = json['name'];
    address = json['address'];
    sex = json['sex'];
    birthDate = MahasFormat.dynamicToDateTime(json['birth_date']);
    email = json['email'];
    createdAt = MahasFormat.dynamicToDateTime(json['created_at']);
    profilePic = json['profile_pic'];
  }

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userUid = json['user_uid'];
    name = json['name'];
    address = json['address'];
    sex = json['sex'];
    birthDate = MahasFormat.dynamicToDateTime(json['birth_date']);
    email = json['email'];
    createdAt = MahasFormat.dynamicToDateTime(json['created_at']);
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> userstoMap() {
    return {
      'id': id,
      'user_uid': userUid,
      'name': name,
      'address': address,
      'sex': sex,
      'birth_date': MahasFormat.dateToString(birthDate),
      'email': email,
      'created_at': MahasFormat.dateToString(createdAt),
      'profile_pic': profilePic
    };
  }

  static List<Users> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => Users.fromJson(e)).toList();
  }

  static List<Users> fromDynamicList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => Users.fromDynamic(e)).toList();
  }
}
