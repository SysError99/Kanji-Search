import 'dart:convert';
import 'package:http/http.dart' as HTTP;
import 'package:flutter/material.dart';

import 'package:kanji_search/dialog.dart';
import 'package:kanji_search/model.kanji.dart';
import 'package:kanji_search/model.kanji.words.dart';
import 'package:kanji_search/view.kanji.words.dart';

class KanjiView extends StatelessWidget {
  Kanji kanji;

  KanjiView({this.kanji});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Column(children: [
          SizedBox(
            height: 16,
          ),
          Text(
            'Kanji Info',
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
      body: SingleChildScrollView(
          child: Center(
              child: Column(children: [
        Text(
          kanji.kanji,
          style: TextStyle(
              fontSize: 144,
              color: const Color(0xFF000000),
              fontWeight: FontWeight.w200,
              fontFamily: "Roboto"),
        ),
        Text(
          '  Grade: ' +
              kanji.grade.toString() +
              '\n' +
              '  Stroke count: ' +
              kanji.strokeCount.toString() +
              '\n'
                  '  Meaning: \n\t- ' +
              kanji.meanings.join('\n\t- ') +
              '\n'
                  '  Kun readings: ' +
              kanji.kunReadings.join(', ') +
              '\n' +
              '  On readings: ' +
              kanji.onReadings.join(', ') +
              '\n' +
              '  Name readings: ' +
              kanji.nameReadings.join(', ') +
              '\n' +
              '  JLPT Level: ' +
              kanji.jlpt.toString() +
              '\n' +
              '  Unicode: ' +
              kanji.unicode +
              '\n',
          style: TextStyle(
              fontSize: 21.0,
              decorationThickness: 400,
              color: const Color(0xFF000000),
              fontWeight: FontWeight.w200,
              fontFamily: "Roboto"),
        ),
        SizedBox(
          height: 16,
        ),
        ElevatedButton(
          child: Text('Words written with ' + kanji.kanji),
          onPressed: () async {
            HTTP.Response res;
            var dialog = new Dlog(context: context);

            try {
              res = await HTTP
                  .get(Uri.https('kanjiapi.dev', '/v1/words/' + kanji.kanji));
            } catch (e) {
              dialog.show(
                  title: 'Unexpected Error',
                  text: 'Error occured while trying to send request ' +
                      e.toString());
              return;
            }

            if (res.statusCode != 200) {
              if (res.statusCode == 404)
                dialog.show(
                    title: 'Not found',
                    text: 'Words written for ' + kanji.kanji + 'is not found.');
              else
                dialog.show(
                    title: 'Network Error',
                    text:
                        'Network error occured: ' + res.statusCode.toString());
              return;
            }

            var json;

            try {
              json = jsonDecode(utf8.decode(res.bodyBytes));
            } catch (e) {
              dialog.show(
                  title: 'Server Error',
                  text: 'Server have sent malformed data.');
              return;
            }

            if (!(json is List)) {
              dialog.show(
                  title: 'Server Error',
                  text: 'Server have sent invalid data type.');
              return;
            }

            List<KanjiWords> kanjiWords = [];

            for (var kanjiWord in json) {
              kanjiWords.add(new KanjiWords.fromJson(kanjiWord));
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => KanjiWordsView(
                          kanji: kanji.kanji,
                          kanjiWords: kanjiWords,
                        )));
          },
        )
      ]))));
}
