import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as HTTP;
import 'package:kana_kit/kana_kit.dart';
import 'package:package_info/package_info.dart';

import 'package:kanji_search/dialog.dart';
import 'package:kanji_search/model.kanji.dart';
import 'package:kanji_search/model.list.kanji.dart';
import 'package:kanji_search/view.about.dart';
import 'package:kanji_search/view.grades.dart';
import 'package:kanji_search/view.kanji.dart';
import 'package:kanji_search/view.list.kanji.dart';

const kanaKit = KanaKit();

String title = 'Kanji Search';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var hContext;
  String inputSearch = '';
  String typeSearch = 'katakana';
  bool romajiMode = false;

  Future<void> gradesFetch(int grade) async {
    if (!(hContext is BuildContext)) return;

    Dlog dialog = new Dlog(context: hContext);
    HTTP.Response res;

    try {
      res = await HTTP.get(
          Uri.https('kanjiapi.dev', '/v1/kanji/grade-' + grade.toString()));
    } catch (e) {
      dialog.show(
          title: 'Unexpected Error',
          text: 'Error while trying to send request: ' + e.toString());
      return;
    }

    if (res.statusCode != 200) {
      if (res.statusCode == 404)
        dialog.show(title: 'Not Found', text: 'Invaild grade specified');
      else
        dialog.show(
            title: 'Network Error',
            text: 'Network error: ' + res.statusCode.toString());
      return;
    }

    var json;

    try {
      json = jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      dialog.show(
          title: 'JSON Conversion Error',
          text: 'Malformed JSON: ' + e.toString());
      return;
    }

    if (!(json is List)) {
      dialog.show(title: 'Data Type Error', text: 'Invalid data type');
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                GradesView(grade: grade, chars: json.cast<String>())));
  }

  @override
  Widget build(BuildContext context) {
    hContext = context;

    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Text(
                    'Kanji Search\n\n' +
                        'KanjiAPI.wiki (onlyskin) & SysError99\n' +
                        'Both published under MIT License',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                decoration: BoxDecoration(
                  color: Colors.black87,
                ),
              ),
              ListTile(
                title: Text('Grade 1'),
                onTap: () {
                  gradesFetch(1);
                },
              ),
              ListTile(
                title: Text('Grade 2'),
                onTap: () {
                  gradesFetch(2);
                },
              ),
              ListTile(
                title: Text('Grade 3'),
                onTap: () {
                  gradesFetch(3);
                },
              ),
              ListTile(
                title: Text('Grade 4'),
                onTap: () {
                  gradesFetch(4);
                },
              ),
              ListTile(
                title: Text('Grade 5'),
                onTap: () {
                  gradesFetch(5);
                },
              ),
              ListTile(
                title: Text('Grade 6'),
                onTap: () {
                  gradesFetch(6);
                },
              ),
              ListTile(
                title: Text('Grade 8'),
                onTap: () {
                  gradesFetch(8);
                },
              ),
              ListTile(
                title: Text('About the app'),
                onTap: () async {
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AboutAppView(
                                packageInfo: packageInfo,
                              )));
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
            child: Center(
                child: Column(children: [
          SizedBox(
            height: 32,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 48.0,
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w200,
                fontFamily: "Roboto"),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32),
                decoration: InputDecoration(
                  labelText: 'Search:',
                ),
                onChanged: (text) {
                  inputSearch = text;
                  typeSearch = 'reading';
                  romajiMode = false;

                  try {
                    if (kanaKit.isKana(text)) return;

                    if (kanaKit.isRomaji(text)) {
                      inputSearch = kanaKit.toKatakana(text);
                      romajiMode = true;
                      return;
                    }

                    if (kanaKit.isKanji(text)) {
                      if (text.length > 1) {
                        typeSearch = 'kanji>1';
                        return;
                      }

                      typeSearch = 'kanji';
                      return;
                    }
                  } catch (e) {}

                  typeSearch = 'unknown';
                },
              )),
          SizedBox(
            height: 32,
          ),
          ElevatedButton(
            child: Text(
              'Search',
              style: TextStyle(fontSize: 32),
            ),
            onPressed: () async {
              var dialog = new Dlog(context: context);
              HTTP.Response res;
              var json;

              if (typeSearch == 'unknown') {
                dialog.show(
                    title: 'Invalid input',
                    text:
                        'It seems like the text you have entered has an invalid type.');
                return;
              } else if (typeSearch == 'kanji > 1') {
                dialog.show(
                    title: 'Unsupported feature',
                    text:
                        'This application does not support multiple Kanji characters.');
                return;
              }

              try {
                res = await HTTP.get(Uri.https(
                    'kanjiapi.dev', '/v1/' + typeSearch + '/' + inputSearch));
              } catch (e) {
                dialog.show(
                    title: 'Uxexpected Error',
                    text: 'Unexpected error occured: ' + e.toString());
                return;
              }

              if (res.statusCode == 200) {
                try {
                  json = jsonDecode(utf8.decode(res.bodyBytes));
                } catch (e) {
                  dialog.show(
                      title: 'Server Error',
                      text: 'Server have sent malformed JSON.');
                  return;
                }

                if (!(json is Map)) {
                  dialog.show(
                      title: 'Data Type Error',
                      text: 'Server have sent malformed data type.');
                  return;
                }
              } else if (!romajiMode) {
                if (res.statusCode == 404)
                  dialog.show(
                      title: 'Kanji Not Found',
                      text: inputSearch + ' is not found!');
                else
                  dialog.show(
                      title: 'Network Error',
                      text: 'Network error occured: ' +
                          res.statusCode.toString());
                return;
              }

              switch (typeSearch) {
                case 'reading':
                  ListKanji resListKanji;
                  List<String> listKanji = [];

                  if (json is Map) {
                    resListKanji = new ListKanji.fromJson(json);
                    listKanji.addAll(resListKanji.mainKanji);
                    listKanji.addAll(resListKanji.nameKanji);
                  }

                  // another request for hiragana
                  try {
                    res = await HTTP.get(Uri.https('kanjiapi.dev',
                        '/v1/reading/' + kanaKit.toHiragana(inputSearch)));
                  } catch (e) {
                    dialog.show(
                        title: 'Error while retrieving hiragana.',
                        text: 'Unknown error occured: ' +
                            e.toString() +
                            ', only katakana-based will be displayed');
                  }

                  if (res.statusCode != 200) {
                    if (res.statusCode != 404) {
                      dialog.show(
                          title:
                              'Network error wiile retrieving hiragana-based characters',
                          text: 'Server responds with: ' +
                              res.statusCode.toString());
                    } else if (!(resListKanji is ListKanji)) {
                      dialog.show(
                          title: 'Not Found',
                          text:
                              'Requested Romaji does not match any Kanji characters.');
                    }
                    return;
                  }

                  try {
                    json = jsonDecode(utf8.decode(res.bodyBytes));
                  } catch (e) {
                    dialog.show(
                        title:
                            'Server error while converting hiragana-based data',
                        text: 'Server have sent malformed data.');
                    return;
                  }

                  resListKanji = new ListKanji.fromJson(json);
                  listKanji.addAll(resListKanji.mainKanji);
                  listKanji.addAll(resListKanji.nameKanji);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListKanjiView(
                                kanjis: listKanji,
                              )));
                  break;

                case 'kanji':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              KanjiView(kanji: new Kanji.fromJson(json))));
                  break;
              }
            },
          ),
          SizedBox(
            height: 32,
          ),
          Text('You may use hiragana, katakana, or single Kanji character.\n' +
              'More than 1 Kanji character is NOT supported.\n' +
              'Swipe left to right to open more menus.\n\n'
                  'Powered by KanjiAPI.dev\n')
        ]))));
  }
}
