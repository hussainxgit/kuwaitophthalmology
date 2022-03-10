import 'package:flutter/material.dart';

Future<void> showQuizScore(BuildContext context, int score) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text('Quiz finish'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your answers score : $score'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<dynamic> makeSureDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('You are about to close the quiz'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("No, i would like to get back"),
            onPressed: () {
              return Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text("Yes i'm finished"),
            onPressed: () {
              return Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
}
