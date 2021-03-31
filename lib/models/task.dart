class Task {
  int _id;
  String _task;
  int get id => this._id;

  set id(int value) => this._id = value;

  String get getTask => this._task;

  set setTask(String task) => this._task = task;

  Task(
    this._task,
  );

  Task.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._task = map['task'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['task'] = this._task;
    return map;
  }
}
