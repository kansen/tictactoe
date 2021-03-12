import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/pages/signup_page.dart';
import 'package:tictactoe/provider/google_signin_provider.dart';

import 'game_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<GoogleSignInProvider>(context);
              if (provider.isGoogleSignIn) {
                return buildLoading(context);
              } else if (snapshot.hasData) {
                return GamePage();
              } else {
                return SignUpWidget();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildLoading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
