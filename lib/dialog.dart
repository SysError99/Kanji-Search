import 'package:flutter/material.dart';

class Dlog {
  BuildContext context;

  Dlog({this.context});

  Future<void> show({title: String, text: String}) =>
      showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) => AlertDialog(
                title: Text(title),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(text),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
}
