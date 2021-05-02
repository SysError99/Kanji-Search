import 'package:flutter/material.dart';

import 'package:kanji_search/view.home.dart';

void main() {
  runApp(MainWidget());
}

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Kanji Search',
      theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.black),
          primaryColor: Colors.black),
      home: HomeView());
}
