class KanjiWords {
  List<KanjiWordsVariants> variants;
  List<KanjiWordsMeanings> meanings;

  KanjiWords({this.variants, this.meanings});

  KanjiWords.fromJson(Map<String, dynamic> json) {
    if (json['variants'] != null) {
      variants = <KanjiWordsVariants>[];
      json['variants'].forEach((v) {
        variants.add(new KanjiWordsVariants.fromJson(v));
      });
    }
    if (json['meanings'] != null) {
      meanings = <KanjiWordsMeanings>[];
      json['meanings'].forEach((v) {
        meanings.add(new KanjiWordsMeanings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.variants != null) {
      data['variants'] = this.variants.map((v) => v.toJson()).toList();
    }
    if (this.meanings != null) {
      data['meanings'] = this.meanings.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KanjiWordsVariants {
  String written;
  String pronounced;
  List<String> priorities;

  KanjiWordsVariants({this.written, this.pronounced, this.priorities});

  KanjiWordsVariants.fromJson(Map<String, dynamic> json) {
    written = json['written'];
    pronounced = json['pronounced'];
    priorities = json['priorities'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['written'] = this.written;
    data['pronounced'] = this.pronounced;
    data['priorities'] = this.priorities;
    return data;
  }
}

class KanjiWordsMeanings {
  List<String> glosses;

  KanjiWordsMeanings({this.glosses});

  KanjiWordsMeanings.fromJson(Map<String, dynamic> json) {
    glosses = json['glosses'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['glosses'] = this.glosses;
    return data;
  }
}
