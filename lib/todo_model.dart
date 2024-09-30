import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String _docId;
  String _title;
  Timestamp _createAt;

  TodoModel(
    this._docId,
    this._title,
    this._createAt,
  );

  String get docId => _docId;
  String get title => _title;
  Timestamp get createAt => _createAt;

  TodoModel.fromMap(map) {
    _docId = map.documentID;
    _title = map['title'];
    _createAt = map['createAt'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['title'] = _title;
    map['createAt'] = _createAt;
    return map;
  }
}

