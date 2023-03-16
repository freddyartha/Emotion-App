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

  static List<EmotionsChartModel> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => EmotionsChartModel.fromJson(e)).toList();
  }
}

class OneEmotion {
  int? id;
  String? description;

  OneEmotion({this.id, this.description});

  OneEmotion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
  }
}
