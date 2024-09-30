import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String _docId;
  String _title;

  TodoModel(
    this._docId,
    this._title,
  );

  String get docId => _docId;
  String get title => _title;

  TodoModel.fromMap(map) {
    _docId = map.documentID;
    _title = map['title'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['title'] = _title;
    return map;
  }
}

