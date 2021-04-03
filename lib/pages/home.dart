import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pemrograman_mobile_uts/database/dbhelper.dart';
import 'package:pemrograman_mobile_uts/models/category.dart';
import 'package:pemrograman_mobile_uts/pages/task.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async'; //pendukung program asinkron
import 'package:flutter_slidable/flutter_slidable.dart';
import 'formCategory.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Category> categoryList;
  String emptyText = "";
  TextEditingController categoryName = new TextEditingController();
  Category category;
  DateTime selectedDate = DateTime.now();

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
                    controller: categoryName,
                    decoration: InputDecoration(
                      labelText: "Category Name",
                      hintText: "Insert category name",
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('Add Item'),
                    onPressed: () async {
                      if (category == null) {
                        category = Category(categoryName.text);
                      } else {
                        category.categoryName = categoryName.text;
                      }
                      int result = await dbHelper.insertCategory(category);
                      if (result > 0) {
                        updateListView();
                      }
                      Navigator.pop(context, category);
                      categoryName.clear();
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
    emptyText = "Empty List";
    if (categoryList == null) {
      categoryList = List<Category>();
    }
    if (categoryList.length > 0) {
      emptyText = "";
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "lib/images/background.jpg"), //Image Asset Background Image
                fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  "To Do List",
                  style: TextStyle(color: Colors.red[200]),
                ),
                Text(
                  "All",
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 100, left: 50),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CircleAvatar(
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
                          "Activities List",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        Text(
                          "You have " + count.toString() + " activites to do",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15, bottom: 20),
                child: Row(
                  children: [
                    Text(
                      "Activities",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " | " +
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
              Container(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.add,
                      color: Colors.red[200],
                    ),
                    onPressed: showBottomSheet,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<Category> navigateToTask(
      BuildContext context, Category category) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return TaskList(category);
    }));
    return result;
  }

  Future<Category> navigateToForm(
      BuildContext context, Category category) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return FormCategory(category);
    }));
    return result;
  }

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        var iconString;
        if (index == 1) {
          iconString = Icon(
            Icons.edit,
            color: Colors.white,
          );
        } else if (index == 2) {
          iconString = Icon(
            Icons.add,
            color: Colors.white,
          );
        }
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Card(
            margin: EdgeInsets.only(bottom: 5),
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green[200],
                child: iconString,
              ),
              title: Text(
                this.categoryList[index].categoryName,
                style: textStyle,
              ),
              subtitle: Text("- "),
              onTap: () async {
                var category =
                    await navigateToTask(context, this.categoryList[index]);
                //TODO 4 Panggil Fungsi untuk Edit data
                updateListView();
                if (category != null) {
                  int result = await dbHelper.updateCategory(category);
                  if (result > 0) {
                    updateListView();
                  }
                }
              },
            ),
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: 'Edit',
              color: Colors.green[200],
              icon: Icons.edit,
              foregroundColor: Colors.white,
              onTap: () async {
                var category =
                    await navigateToForm(context, this.categoryList[index]);
                //TODO 4 Panggil Fungsi untuk Edit data
                if (category != null) {
                  int result = await dbHelper.updateCategory(category);
                  if (result > 0) {
                    updateListView();
                  }
                }
              },
            ),
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () async {
                //TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Item
                int id =
                    this.categoryList[index].id; // get id from sqlite database
                int result = await dbHelper
                    .deleteCategory(id); // delete by id from table
                categoryList.removeAt(index); // delete by index from list
                updateListView();
              },
            ),
          ],
        );
      },
    );
  }

//update List item
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
//TODO 1 Select data dari DB
      Future<List<Category>> categoryListFuture = dbHelper.getCategoryList();
      categoryListFuture.then((categoryList) {
        setState(() {
          this.categoryList = categoryList;
          this.count = categoryList.length;
        });
      });
    });
  }
}
