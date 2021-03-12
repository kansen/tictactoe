import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/components/alert.dart';
import 'package:tictactoe/models/player.dart';
import 'package:tictactoe/pages/scoreboard_page.dart';
import 'package:tictactoe/provider/database_service.dart';
import 'package:tictactoe/provider/google_signin_provider.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final user = FirebaseAuth.instance.currentUser;
  final scoresRef = FirebaseFirestore.instance.collection('scores');

  // Initialize an empty board
  List<int> matrix = [0, 0, 0, 0, 0 , 0, 0, 0, 0];

  // Setting winning matrix
  var win_list = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]];

  // Player's winning sets
  Set<int> winning_set = new Set();

  int current = Player.N;
  int pplayer = 0;
  bool isStart = false;
  int currentWinCount = 0;
  int currentGameCount = 0;
  String currentDocId;

  void play(int index) {
    setState(() {
      matrix[index] = current;
      if (current == Player.O) {
        current = Player.X;
      } else {
        current = Player.O;
      }
    });
  }

  void reset() {
    setState(() {
      matrix = [0, 0, 0, 0, 0 , 0, 0, 0, 0];
      winning_set.clear();
      isStart = false;
    });
  }

  /// Getting current moves from the player so we can use that to
  /// check our winning position
  ///
  /// return List of moves
  List getCurrentMoves() {

    // Since the player has update to the next so
    // we have to switch back to obain the one that just
    // click the position
    if (current == Player.O) {
      pplayer = Player.X;
    } else {
      pplayer = Player.O;
    }

    // Find the moves that made from current player
    List currentMoves = [];
    for (var i = 0; i < matrix.length ; i++ ) {
      if (pplayer == matrix[i]) {
        currentMoves.add(i);
      }
    }
    return currentMoves;
  }

  void checkWinning() {
    setState(() {
      isStart = true;
    });

    var moves = getCurrentMoves();
    var iter = win_list.iterator;
    if (moves.length < 3) {
      // Don't need to check if its less than 3.
      return;
    }
    if (!matrix.contains(Player.N)) {
      if (currentDocId != null) {
        var winner = <String, dynamic> {
          'game_count' : currentGameCount + 1,
        };
        DatabaseService.update("scores", currentDocId, winner);
      } else {
        var winner = <String, dynamic> {
          'user_id' : user.email,
          'game_count' : currentGameCount + 1,
        };
        DatabaseService.add("scores", winner);
      }
      // When all places have been checked, there is no more steps left.
      alertDialog(context, "Game Over", "Please press OK to start a new game.", reset);
      return;
    }

    while (iter.moveNext()) {
      var win = iter.current;
      if (win.every((item) => moves.contains(item))) {
        // Comparing if all moves from the current players have any
        // matches on the winning positions.
        setState(() {
          winning_set = win.toSet();
        });
        if (currentDocId != null) {
          var winner = <String, dynamic> {
            'game_count' : currentGameCount + 1,
            'win_count' : currentWinCount + 1,
          };
          DatabaseService.update("scores", currentDocId, winner);
        } else {
          var winner = <String, dynamic> {
            'user_id' : user.email,
            'game_count' : currentGameCount + 1,
            'win_count' : currentWinCount + 1,
          };
          DatabaseService.add("scores", winner);
        }
        alertDialog(context, "Player${pplayer} Won!", "Please press OK to start a new game.", reset);
      }
    }
  }

  setUserData(List<QueryDocumentSnapshot> users) {
    if (users.length > 0) {
      var currentUser = users.elementAt(0);
      currentDocId = currentUser.id;
      currentWinCount = currentUser.get('win_count');
      currentGameCount = currentUser.get('game_count');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
                color: Colors.white,
                height: 80,
                child: DrawerHeader(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        maxRadius: 25,
                        backgroundImage: NetworkImage(user.photoURL),
                      ),
                      SizedBox(width: 20,),
                      Text(
                        user.displayName,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                )
            ),
            Container(
                color: Colors.white,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text("Logout"),
                      onTap: () {
                        final provider =
                          Provider.of<GoogleSignInProvider>(context, listen: false);
                        provider.logout();
                      },
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: TextButton(
            child: Text('Scoreboard'),
            style: TextButton.styleFrom(
              primary: Colors.orange,
              onSurface: Colors.teal,
              shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              textStyle: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScoreboardPage()));
            }
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: scoresRef
                  .where("user_id", isEqualTo: user.email)
                  .orderBy('win_count').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  setUserData(snapshot.data.docs);
                }
                final List<QueryDocumentSnapshot> children = snapshot.data.docs;
                setUserData(children);
                return SizedBox(height: 10,);
              }
          ),
          Padding(
              padding: EdgeInsets.all(50),
              child: TextButton(
                  child: Text('Restart'),
                  style: TextButton.styleFrom(
                    primary: isStart ? Colors.teal : Colors.black12,
                    textStyle: TextStyle(
                        color: Colors.orange,
                        fontSize: 20,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  onPressed: () {
                    if (isStart) {
                      reset();
                    }
                  }
              ),
          ),

          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              // generate the widgets that will display the board
              children: List.generate(matrix.length, (index) {
                return Place(index, matrix.elementAt(index), play, winning_set.contains(index));
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Draw the board with current play from players and display matched \
  /// row in red color.
  Widget Place(int index, int value, Function(int index) tap, bool isWin) {

    void _handleTap() {
      if (value == 0) {
        // Only need to tap the position if its still unchecked.
        tap(index);
      }

      checkWinning();
    }

    // Initialize border style
    final BorderSide side = BorderSide(
      color: Colors.black,
      width: 2.0,
      style: BorderStyle.solid,
    );

    // Draw the borders based on the place location.
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

    // Display the character when players checked
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

    // Tappable places that display the character and color based on its status.
    return GestureDetector(
        onTap: () {
          _handleTap();
        },
        child: Container(
          margin: const EdgeInsets.all(0.0),
          decoration: BoxDecoration(
            border: drawBorder(),
            color: isWin ? Colors.red : Colors.white,
          ),
          child: Center(
            child: Text(display(value), style: TextStyle(fontSize: 20))
          ),
        ),
      );
    }

}
