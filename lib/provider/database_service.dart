import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  static final _db = FirebaseFirestore.instance;

  static Future<void> add(String collection, Map<String, dynamic> content) async {
    await _db
        .collection(collection).doc()
        .set(content);
  }

  static Future<void> update(String collection, String id, Map<String, dynamic> content) async {
    await _db.collection(collection).doc(id).update(content).catchError((e) {
      print(e);
    });
    return true;
  }

  static Future<void> delete(String collection, String id) async {
    await _db.collection(collection).doc(id).delete().catchError((e) {
      print(e);
    });
    return true;
  }
}