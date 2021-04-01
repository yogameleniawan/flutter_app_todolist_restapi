class Category {
  int _id;
  String _categoryName;
  int get id => this._id;

  set id(int value) => this.id = value;

  String get categoryName => this._categoryName;

  set categoryName(String value) => this._categoryName = value;

  Category(this._categoryName);

  Category.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._categoryName = map['categoryName'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['categoryName'] = this._categoryName;
    return map;
  }
}
