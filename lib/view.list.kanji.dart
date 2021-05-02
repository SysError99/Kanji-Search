import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as HTTP;

import 'package:kanji_search/dialog.dart';
import 'package:kanji_search/model.kanji.dart';
import 'package:kanji_search/view.kanji.dart';

class ListKanjiView extends StatelessWidget {
  List<String> kanjis;

  ListKanjiView({this.kanjis});

  @override
  Widget build(BuildContext context) {
    Dlog dialog = new Dlog(context: context);
    List<Widget> widgets = [];

    for (var kanji in kanjis) {
      widgets.add(new TextButton(
        child:
            Text(kanji, style: TextStyle(fontSize: 64, color: Colors.black87)),
        onPressed: () async {
          HTTP.Response res;

          try {
            res =
                await HTTP.get(Uri.https('kanjiapi.dev', '/v1/kanji/' + kanji));
          } catch (e) {
            dialog.show(
                title: 'Unknown error',
                text: 'Unknown error occured: ' + e.toString());
            return;
          }

          if (res.statusCode != 200) {
            dialog.show(
                title: 'Something unexpected happened',
                text: 'Error on the network: ' + res.statusCode.toString());
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

          if (!(json is Map)) {
            dialog.show(
                title: 'Server Error',
                text: 'Server have sent invalid data type.');
            return;
          }

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      KanjiView(kanji: new Kanji.fromJson(json))));
        },
      ));
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Column(children: [
          SizedBox(
            height: 16,
          ),
          Text(
            'List of Kanji',
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
      body: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 4 / 3,
        children: widgets,
      ),
    );
  }
}
