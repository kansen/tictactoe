import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget alertDialog (BuildContext context, String title, String content, Function() reset ) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            reset();
            Navigator.of(ctx).pop();
          },
          child: Text("OK"),
        ),
      ],
    ),
  );
}