import 'dart:convert';

class Category {
  String _id;
  String _categoryName;
  String _icon;

  get categoryName => this._categoryName;

  set categoryName(value) => this._categoryName = value;

  String get id => this._id;

  set id(String value) => this._id = value;

  get icon => this._icon;

  set icon(value) => this._icon = value;

  Category(this._categoryName, this._icon);

  Map<String, dynamic> toJson() {
    return {"name": categoryName, "icon": icon};
  }

  Category.fromJson(Map<String, dynamic> parsedJson) {
    this._id = parsedJson['id'];
    this._categoryName = parsedJson['name'];
    this._icon = parsedJson['icon'];
  }
}
