class Kanji {
  String kanji;
  int grade;
  int strokeCount;
  List<String> meanings;
  List<String> kunReadings;
  List<String> onReadings;
  List<String> nameReadings;
  int jlpt;
  String unicode;
  String heisigEn;

  Kanji(jsonDecode, 
      {this.kanji,
      this.grade,
      this.strokeCount,
      this.meanings,
      this.kunReadings,
      this.onReadings,
      this.nameReadings,
      this.jlpt,
      this.unicode,
      this.heisigEn});

  Kanji.fromJson(Map<String, dynamic> json) {
    kanji = json['kanji'];
    grade = json['grade'];
    strokeCount = json['stroke_count'];
    meanings = json['meanings'].cast<String>();
    kunReadings = json['kun_readings'].cast<String>();
    onReadings = json['on_readings'].cast<String>();
    nameReadings = json['name_readings'].cast<String>();
    jlpt = json['jlpt'];
    unicode = json['unicode'];
    heisigEn = json['heisig_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kanji'] = this.kanji;
    data['grade'] = this.grade;
    data['stroke_count'] = this.strokeCount;
    data['meanings'] = this.meanings;
    data['kun_readings'] = this.kunReadings;
    data['on_readings'] = this.onReadings;
    data['name_readings'] = this.nameReadings;
    data['jlpt'] = this.jlpt;
    data['unicode'] = this.unicode;
    data['heisig_en'] = this.heisigEn;
    return data;
  }
}
