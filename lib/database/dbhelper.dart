import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pemrograman_mobile_uts/models/category.dart';
import 'package:pemrograman_mobile_uts/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;

  DbHelper._createObject();

  Future<Database> initDb() async {
    //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'todolist.db';
    //untuk mentabase dentukan nama dan lokasi yg dibuat

    //create, read databases
    var itemDatabase = openDatabase(path,
        version: 1, onCreate: _createDb, onUpgrade: _onUpgrade);
    //create, read databases

    return itemDatabase; //mengembalikan nilai object sebagai hasil dari fungsinya
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      // db.execute(""); // SQL Query
    }
  }

//buat tabel baru dengan nama item
  void _createDb(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute(
        "CREATE TABLE category ( id INTEGER PRIMARY KEY AUTOINCREMENT, categoryName TEXT)");
    batch.execute(
        "CREATE TABLE task ( id INTEGER PRIMARY KEY AUTOINCREMENT, taskName TEXT, idCategory INTEGER)");
    List<dynamic> res = await batch.commit();
  }

// Category Table
//select databases
  Future<List<Map<String, dynamic>>> selectCategory() async {
    Database db = await this.initDb();
    var mapList = await db.query('category', orderBy: 'id');
    return mapList;
  }

//insert databases
  Future<int> insertCategory(Category object) async {
    Database db = await this.database;
    int count = await db.insert('category', object.toMap());
    return count;
  }

//update databases
  Future<int> updateCategory(Category object) async {
    Database db = await this.database;
    int count = await db.update('category', object.toMap(),
        where: 'id=?', whereArgs: [object.id]);
    return count;
  }
  //delete databases

  Future<int> deleteCategory(int id) async {
    Database db = await this.database;
    int count = await db.delete('category', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Category>> getCategoryList() async {
    var categoryMapList = await selectCategory();
    int count = categoryMapList.length;
    List<Category> categoryList = List<Category>();
    for (int i = 0; i < count; i++) {
      categoryList.add(Category.fromMap(categoryMapList[i]));
    }
    return categoryList;
  }
  // Category Table

  // Task Table
//select databases
  Future<List<Map<String, dynamic>>> selectTask(int idCategory) async {
    Database db = await this.initDb();
    var mapList = await db.query('task', where: '"idCategory" = $idCategory');
    return mapList;
  }

//insert databases
  Future<int> insertTask(Task object) async {
    Database db = await this.database;
    int count = await db.insert('task', object.toMap());
    return count;
  }

//update databases
  Future<int> updateTask(Task object) async {
    Database db = await this.database;
    int count = await db
        .update('task', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }
  //delete databases

  Future<int> deleteTask(int id) async {
    Database db = await this.database;
    int count = await db.delete('task', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Task>> getTaskList(int idCategory) async {
    var taskMapList = await selectTask(idCategory);
    int count = taskMapList.length;
    List<Task> taskList = List<Task>();
    for (int i = 0; i < count; i++) {
      taskList.add(Task.fromMap(taskMapList[i]));
    }
    return taskList;
  }
  // Task Table

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }
}
