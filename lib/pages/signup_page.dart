import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/google_singup_button_widget.dart';

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      buildSignUp(context),
    ],
  );

  Widget buildSignUp(BuildContext context) => Column(
    children: [
      Spacer(),
      Align(
        alignment: Alignment.centerLeft,
        child: Center(
          child: Container(
            child: Text(
              'TicTacToe',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      Spacer(),
      GoogleSignUpButtonWidget(),
      SizedBox(height: 12),
      Spacer(),
    ],
  );
}
