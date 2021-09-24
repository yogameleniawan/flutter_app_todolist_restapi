import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pemrograman_mobile_uts/database/httpservice.dart';
import 'package:pemrograman_mobile_uts/models/category.dart';
import 'package:pemrograman_mobile_uts/models/task.dart';
import 'package:sqflite/sqflite.dart';

import 'formTask.dart';

class TaskList extends StatefulWidget {
  final Category category;
  TaskList(this.category);

  @override
  _TaskListState createState() => _TaskListState(this.category);
}

class _TaskListState extends State<TaskList> {
  _TaskListState(this.category);

  HTTPService service;

  List listTask;
  int listCount = 0;
  TextEditingController taskName = new TextEditingController();
  Category category;
  Task task;
  DateTime selectedDate = DateTime.now();

  Future initialize() async {
    listTask = [];
    listTask = await service.getTask(category_id: category.id);
    setState(() {
      listCount = listTask.length;
    });
  }

  @override
  void initState() {
    super.initState();
    service = new HTTPService();
    initialize();
    // updateListView();
  }

  void showBottomSheet() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: 200,
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
                    style: ElevatedButton.styleFrom(primary: Colors.green[300]),
                    onPressed: () async {
                      if (task == null) {
                        task = Task(taskName.text, category.id);
                      } else {
                        task.taskName = taskName.text;
                      }
                      // int result = await dbHelper.insertTask(task);
                      // if (result > 0) {
                      //   updateListView();
                      // }
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
    if (listTask == null) {
      listTask = List<Task>();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Text(
              "|  ",
              style: TextStyle(color: Colors.black54, fontSize: 25),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.categoryName,
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Text(
                  "All",
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_box,
              color: Colors.green[200],
            ),
            onPressed:
                showBottomSheet, // Call function addItemToList to Add item to list
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 50, left: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green[200],
                    child: Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Task List",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    Text(
                      "You have " + listCount.toString() + " task to do",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Task",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('EEEEEE, MMMM d').format(
                      selectedDate), // get date format with EEEEEE (Full character of Day -> Sunday, Monday, Tuesday)
                  // EEE (Just 3 character of day name -> Sun, Mon, Tue)
                  // MMMM (Full character of Month -> January, February, March)
                  // MM (Just 3 character of month name -> Jan, Feb, Mar)
                  // d show the date (1 - 31)
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          Expanded(
            child: createListView(),
          ),
        ]),
      ),
    );
  }

  Future<Task> navigateToForm(
      BuildContext context, Task task, String idCategory) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return FormTask(idCategory, task);
    }));
    return result;
  }

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: listCount,
      itemBuilder: (BuildContext context, int index) {
        String idTask = this.listTask[index].id;
        var iconColor;
        var iconString;
        var textStyle;
        if (category.icon == "No Category") {
          textStyle = TextStyle(color: Colors.black54, fontSize: 25);
          iconColor = Colors.black54;
        } else if (category.icon == "Work") {
          iconColor = Colors.red[200];
          iconString = Icon(
            Icons.work,
            color: Colors.white,
          );
          textStyle = TextStyle(color: Colors.red[200], fontSize: 25);
        } else if (category.icon == "Shopping") {
          iconColor = Colors.blue[300];
          iconString = Icon(
            Icons.shopping_cart,
            color: Colors.white,
          );
          textStyle = TextStyle(color: Colors.blue[300], fontSize: 25);
        } else if (category.icon == "Home") {
          iconColor = Colors.green[300];
          iconString = Icon(
            Icons.home,
            color: Colors.white,
          );
          textStyle = TextStyle(color: Colors.green[300], fontSize: 25);
        }

        return InkWell(
          onLongPress: () {
            _showcontent(index, idTask);
          },
          child: Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: iconColor,
                child: iconString,
              ),
              title: Text(
                this.listTask[index].taskName,
                style: textStyle,
              ),
              subtitle: Text("Task"),
              trailing: GestureDetector(
                child: Icon(Icons.edit),
                onTap: () async {
                  var task = await navigateToForm(
                      context, this.listTask[index], category.id);
                  //TODO 4 Panggil Fungsi untuk Edit data
                  if (task != null) {
                    // int result = await dbHelper.updateTask(task);
                    // if (result > 0) {
                    //   updateListView();
                    // }
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

//update List item
  void updateListView() {
//     final Future<Database> dbFuture = dbHelper.initDb();
//     dbFuture.then((database) {
// //TODO 1 Select data dari DB
//       Future<List<Task>> taskListFuture = dbHelper.getTaskList(idCategory);
//       taskListFuture.then((listTask) {
//         setState(() {
//           this.listTask = listTask;
//           this.count = listTask.length;
//         });
//       });
//     });
  }

  void _showcontent(int index, String idTask) {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Remove Item'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text('Are you sure to remove task?'),
              ],
            ),
          ),
          actions: [
            new FlatButton(
              child: new Text('YES'),
              onPressed: () async {
                Navigator.of(context).pop();
                // int result = await dbHelper
                //     .deleteTask(idTask); // delete by id from table
                // listTask.removeAt(index); // delete by index from list
                // updateListView();
              },
            ),
            new FlatButton(
              child: new Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
