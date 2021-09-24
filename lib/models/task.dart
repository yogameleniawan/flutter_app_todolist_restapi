import 'package:flutter/services.dart';

class Task {
  String _id;
  String _taskName;
  String _idCategory;

  String get id => this._id;

  set id(String value) => this._id = value;

  get taskName => this._taskName;

  set taskName(value) => this._taskName = value;

  get idCategory => this._idCategory;

  set idCategory(value) => this._idCategory = value;

  Task(this._taskName, this._idCategory);

  Task.fromJson(Map<String, dynamic> parsedJson) {
    this._id = parsedJson['id'];
    this._taskName = parsedJson['description'];
    this._idCategory = parsedJson['category_id'];
  }
}
