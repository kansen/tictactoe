import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  String id;
  String player1;
  String player2;
  var matrix;
  String winner;
  Timestamp create_at;

  Game(this.id, this.player1, this.player2, this.matrix,
      this.winner, this.create_at);
}