import 'package:flutter/material.dart';

import 'package:kanji_search/model.kanji.words.dart';

class KanjiWordsView extends StatelessWidget {
  String kanji;
  List<KanjiWords> kanjiWords;

  KanjiWordsView({this.kanji, this.kanjiWords});

  @override
  Widget build(BuildContext context) {
    List<Widget> words = [];
    var wordCounter = 1;

    for (var kanjiWord in kanjiWords) {
      var glossCounter = 1;
      var wordStr = '  ' + wordCounter.toString() + '. Variants\n';

      for (var variant in kanjiWord.variants) {
        wordStr +=
            '  \t- ' + variant.written + ' (' + variant.pronounced + ')\n';
      }

      wordStr += '  Meanings\n';

      for (var meaning in kanjiWord.meanings) {
        wordStr += '  \t- Glossary ' +
            glossCounter.toString() +
            '\n\t\t- ' +
            meaning.glosses.join('\n\t\t- ');
        glossCounter++;
      }

      words.addAll([
        Text(
          wordStr,
          style: TextStyle(
              fontSize: 21.0,
              decorationThickness: 400,
              color: const Color(0xFF000000),
              fontWeight: FontWeight.w200,
              fontFamily: "Roboto"),
        ),
        SizedBox(
          height: 16,
        )
      ]);
      wordCounter++;
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black87),
          title: Column(children: [
            SizedBox(
              height: 16,
            ),
            Text(
              'Words written with ' + kanji,
              style: TextStyle(
                  fontSize: 48.0,
                  decorationThickness: 400,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
            ),
            SizedBox(
              height: 16,
            ),
          ]),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: ListView(
          children: words,
        ));
  }
}
