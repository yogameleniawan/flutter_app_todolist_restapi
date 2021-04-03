class Category {
  int _id;
  String _categoryName;
  String _icon;
  int get id => this._id;

  set id(int value) => this.id = value;

  String get categoryName => this._categoryName;

  set categoryName(String value) => this._categoryName = value;

  String get icon => this._icon;

  set icon(String value) => this._icon = value;

  Category(this._categoryName, this._icon);

  Category.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._categoryName = map['categoryName'];
    this._icon = map['icon'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['categoryName'] = this._categoryName;
    map['icon'] = this._icon;
    return map;
  }
}
