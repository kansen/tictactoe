import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/provider/google_signin_provider.dart';

class GoogleSignUpButtonWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(60),
        child: Image.asset('assets/images/google_sign_in.png'),
      ),
      onTap: () {
        final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.login();
      },
    );
  }
}
