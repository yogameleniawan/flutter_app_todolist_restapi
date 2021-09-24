import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pemrograman_mobile_uts/database/httpservice.dart';
import 'package:pemrograman_mobile_uts/models/category.dart';
import 'package:pemrograman_mobile_uts/models/task.dart';
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
  HTTPService service;
  int countCategory = 0;
  int countTask = 0;
  List categoryList;
  TextEditingController categoryName = new TextEditingController();
  Category category;
  DateTime selectedDate = DateTime.now();
  List listTask;
  String id;

  Future initialize() async {
    categoryList = [];
    categoryList = await service.getCategory();
    setState(() {
      countCategory = categoryList.length;
    });
  }

  @override
  void initState() {
    super.initState();
    service = new HTTPService();
    initialize();
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
                    controller: categoryName,
                    decoration: InputDecoration(
                      labelText: "Category Name",
                      hintText: "Insert category name",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.green[300]),
                      child: const Text('Add Category'),
                      onPressed: () async {
                        if (category == null) {
                          category = Category(categoryName.text, "No Category");
                        } else {
                          // category.categoryName = categoryName.text;
                        }
                        // int result = await dbHelper.insertCategory(category);
                        // if (result > 0) {
                        //   updateListView();
                        // }
                        Navigator.pop(context, category);
                        categoryName.clear();
                      },
                    ),
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
                          "You have " +
                              countCategory.toString() +
                              " activites to do",
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
    // TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: countCategory,
      itemBuilder: (BuildContext context, int index) {
        var iconColor;
        var iconString;
        var textStyle;
        // id = this.categoryList[index].id;
        if (categoryList[index].icon == "No Category") {
          textStyle = TextStyle(color: Colors.black54, fontSize: 25);
          iconColor = Colors.black54;
        } else if (categoryList[index].icon == "Work") {
          iconColor = Colors.red[200];
          iconString = Icon(
            Icons.work,
            color: Colors.white,
          );
          textStyle = TextStyle(color: Colors.red[200], fontSize: 25);
        } else if (categoryList[index].icon == "Shopping") {
          iconColor = Colors.blue[300];
          iconString = Icon(
            Icons.shopping_cart,
            color: Colors.white,
          );
          textStyle = TextStyle(color: Colors.blue[300], fontSize: 25);
        } else if (categoryList[index].icon == "Home") {
          iconColor = Colors.green[300];
          iconString = Icon(
            Icons.home,
            color: Colors.white,
          );
          textStyle = TextStyle(color: Colors.green[300], fontSize: 25);
        }
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Card(
            margin: EdgeInsets.only(bottom: 5),
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: iconColor,
                child: iconString,
              ),
              title: Text(
                this.categoryList[index].categoryName,
                style: textStyle,
              ),
              subtitle: Text(categoryList[index].icon),
              onTap: () async {
                var category =
                    await navigateToTask(context, this.categoryList[index]);
                // updateListView();
                if (category != null) {
                  // int result = await dbHelper.updateCategory(category);
                  // if (result > 0) {
                  //   // updateListView();
                  // }
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
                  // int result = await dbHelper.updateCategory(category);
                  // if (result > 0) {
                  //   // updateListView();
                  // }
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
                // String id =
                //     this.categoryList[index].id; // get id from sqlite database
                // String result = await dbHelper
                //     .deleteCategory(id); // delete by id from table
                // categoryList.removeAt(index); // delete by index from list
                // updateListView();
              },
            ),
          ],
        );
      },
    );
  }

//update List item
  void updateListView() {
//     final Future<Database> dbFuture = dbHelper.initDb();
//     dbFuture.then((database) {
// //TODO 1 Select data dari DB
//       Future<List<Category>> categoryListFuture = dbHelper.getCategoryList();
//       categoryListFuture.then((categoryList) {
//         setState(() {
//           this.categoryList = categoryList;
//           this.countCategory = categoryList.length;
//         });
//       });
//     });
  }
}
