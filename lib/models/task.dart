class Task {
  int _id;
  String _taskName;
  int _idCategory;
  get idCategory => this._idCategory;

  set idCategory(value) => this._idCategory = value;

  String get taskName => this._taskName;

  set taskName(String value) => this._taskName = value;
  int get id => this._id;

  set id(int value) => this._id = value;

  Task(this._taskName, this._idCategory);

  Task.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._taskName = map['taskName'];
    this._idCategory = map['idCategory'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['taskName'] = this._taskName;
    map['idCategory'] = this._idCategory;
    return map;
  }
}
