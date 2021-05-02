class ListKanji {
  String reading;
  List<String> mainKanji;
  List<String> nameKanji;

  ListKanji({this.reading, this.mainKanji, this.nameKanji});

  ListKanji.fromJson(Map<String, dynamic> json) {
    reading = json['reading'];
    mainKanji = json['main_kanji'].cast<String>();
    nameKanji = json['name_kanji'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reading'] = this.reading;
    data['main_kanji'] = this.mainKanji;
    data['name_kanji'] = this.nameKanji;
    return data;
  }
}
