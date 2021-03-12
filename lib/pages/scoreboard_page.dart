import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScoreboardPage extends StatelessWidget {

  final scoresRef = FirebaseFirestore.instance.collection('scores');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.arrow_back),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: Text(
                      "Scoreboard",
                    ),
                    tileColor: Colors.orange,
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: scoresRef
                          .where("win_count", isGreaterThan: 0)
                          .orderBy("win_count", descending: true)
                          .limit(20)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) return Center(
                            child: Text(
                                "Unable to loading scores, please contact support",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                )
                            )
                        );
                        if (!snapshot.hasData) return Center(
                            child: Text(
                                "No Scores Yet",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                )
                            )
                        );
                        final List<QueryDocumentSnapshot> children = snapshot.data.docs;
                        return children.length > 0 ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: children.length,
                            itemBuilder: (context, index){
                              return Container(
                                child: Row(
                                  children: [
                                    Text(
                                        '${children[index].get('user_id')}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                        )
                                    ),
                                    SizedBox(width: 20.0,),
                                    Text(
                                        '${children[index].get('win_count')} won(s)',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                        )
                                    ),
                                  ],
                                ),
                              );
                            }
                        ) : Center(
                            child: Text(
                                "No Scores Yet",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                )
                            )
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
          ),

        ),
      );
  }
}
