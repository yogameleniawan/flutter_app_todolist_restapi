import 'package:flutter/material.dart';
import 'package:pemrograman_mobile_uts/database/dbhelper.dart';
import 'package:pemrograman_mobile_uts/models/category.dart';
import 'package:pemrograman_mobile_uts/models/task.dart';
import 'package:sqflite/sqflite.dart';

class TaskList extends StatefulWidget {
  final Category category;
  TaskList(this.category);

  @override
  _TaskListState createState() => _TaskListState(this.category);
}

class _TaskListState extends State<TaskList> {
  _TaskListState(this.category);

  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Task> listTask;
  String emptyText = "";
  TextEditingController taskName = new TextEditingController();
  int idCategory;
  Category category;
  Task task;

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  void showBottomSheet() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: 300,
            margin: EdgeInsets.only(left: 10, right: 10),
            // color: Colors.amber,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.expand_more_outlined),
                  TextFormField(
                    controller: taskName,
                    decoration: InputDecoration(
                      labelText: "Task Name",
                      hintText: "Insert task name",
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('Add Task'),
                    onPressed: () async {
                      if (task == null) {
                        task = Task(taskName.text, idCategory);
                      } else {
                        task.taskName = taskName.text;
                      }
                      int result = await dbHelper.insertTask(task);
                      if (result > 0) {
                        updateListView();
                      }
                      Navigator.pop(context, task);
                      taskName.clear();
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (category != null) {
      idCategory = category.id;
    }
    emptyText = "Empty List";
    if (listTask == null) {
      listTask = List<Task>();
    }
    if (listTask.length > 0) {
      emptyText = "";
    }
    return Scaffold(
      appBar: AppBar(title: Text(category.categoryName)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(emptyText),
        ),
        Expanded(
          child: createListView(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text("Tambah Item"),
              onPressed: showBottomSheet,
            ),
          ),
        ),
      ]),
    );
  }

  Future<Category> navigateToForm(BuildContext context, Task task) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      // return EntryForm(category);
    }));
    return result;
  }

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.shopping_cart_rounded),
            ),
            title: Text(
              this.listTask[index].taskName,
              style: textStyle,
            ),
            subtitle: Text("- "),
            trailing: GestureDetector(
              child: Icon(Icons.edit),
              onTap: () async {
                var category =
                    await navigateToForm(context, this.listTask[index]);
                //TODO 4 Panggil Fungsi untuk Edit data
                if (task != null) {
                  int result = await dbHelper.updateTask(task);
                  if (result > 0) {
                    updateListView();
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }

//update List item
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
//TODO 1 Select data dari DB
      Future<List<Task>> taskListFuture = dbHelper.getTaskList();
      taskListFuture.then((listTask) {
        setState(() {
          this.listTask = listTask;
          this.count = listTask.length;
        });
      });
    });
  }
}
