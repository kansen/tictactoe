import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Place extends StatelessWidget {

  final int index;
  final int value;
  //final Function(int index) onTap;

  Place({this.index, this.value});

  final BorderSide side = BorderSide(
    color: Colors.black,
    width: 2.0,
    style: BorderStyle.solid,
  );

  Border drawBorder() {
    Border drawBorder = Border.all();

    switch(index) {
      case 0:
        drawBorder = Border(bottom: side, right: side);
        break;
      case 1:
        drawBorder = Border(left: side, bottom: side, right: side);
        break;
      case 2:
        drawBorder = Border(left: side, bottom: side);
        break;
      case 3:
        drawBorder = Border(top: side, right: side, bottom: side);
        break;
      case 4:
        drawBorder = Border(left: side, top: side, bottom: side, right: side);
        break;
      case 5:
        drawBorder = Border(top: side, left: side, bottom: side);
        break;
      case 6:
        drawBorder = Border(top: side, right: side);
        break;
      case 7:
        drawBorder = Border(left: side, top: side, right: side);
        break;
      case 8:
        drawBorder = Border(left: side, top: side);
        break;
    }

    return drawBorder;
  }

  String display(int value) {
    String display = "";
    switch(value) {
      case 0:
        display = "";
        break;
      case 1:
        display = "X";
        break;
      case 2:
        display =  "O";
        break;
    }
    return display;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
            border: drawBorder()
        ),
        child: Center(
            child: Text(display(value), style: TextStyle(fontSize: 20))
        ),
      ),
    );
  }
}
