import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:how_many_minutes_left/todo_model.dart';

class TodoService extends ChangeNotifier {
  String uid;
  List _todo;

  TodoService();

  CollectionReference get dataPath =>
      Firestore.instance.collection('users/$uid/todo');
  List get todo => _todo;

  void init(List<DocumentSnapshot> documents) {
    _todo = documents.map((doc) => TodoModel.fromMap(doc)).toList();
  }

  void addTitle(title) {
    dataPath.document().setData({'title': title});
  }

  void deleteDocument(docId) {
    dataPath.document(docId).delete();
  }
}

