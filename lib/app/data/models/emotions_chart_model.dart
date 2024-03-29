class EmotionsChartModel {
  String? emotionTitle;
  OneEmotion? oneEmotion;

  EmotionsChartModel({this.emotionTitle, this.oneEmotion});

  EmotionsChartModel.fromJson(Map<String, dynamic> json) {
    emotionTitle = json['emotion_title'];
    oneEmotion = json['one_emotion'] != null
        ? OneEmotion.fromJson(json['one_emotion'])
        : null;
  }

  Map<String, dynamic> emotionsListtoMap() {
    return {
      'emotion_title': emotionTitle,
      'one_emotion': oneEmotion?.oneEmotionsListtoMap()
    };
  }

  static List<EmotionsChartModel> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => EmotionsChartModel.fromJson(e)).toList();
  }
}

class OneEmotion {
  int? id;
  String? description;
  String? image;

  OneEmotion({this.id, this.description, this.image});

  OneEmotion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> oneEmotionsListtoMap() {
    return {
      'id': id,
      'description': description,
      'image': image,
    };
  }
}
