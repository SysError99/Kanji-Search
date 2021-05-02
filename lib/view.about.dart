import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AboutAppView extends StatelessWidget {
  PackageInfo packageInfo;

  AboutAppView({this.packageInfo});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Column(children: [
          SizedBox(
            height: 16,
          ),
          Text(
            'About App',
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
          '安',
          style: TextStyle(
              fontSize: 144,
              color: const Color(0xFF000000),
              fontWeight: FontWeight.w200,
              fontFamily: "Roboto"),
        ),
        Center(child: Text(
          'Kanji Search\n' +
              'Version ' +
              packageInfo.version +
              ' (build ' +
              packageInfo.buildNumber +
              ')\n\n'
                  'Powered by KanjiApi.dev\n' +
              'onlyskin & SysError99\n'
                  'Published under MIT License',
          style: TextStyle(
              fontSize: 21.0,
              decorationThickness: 400,
              color: const Color(0xFF000000),
              fontWeight: FontWeight.w200,
              fontFamily: "Roboto"),
        )),
        SizedBox(
          height: 16,
        ),
      ]))));
}
