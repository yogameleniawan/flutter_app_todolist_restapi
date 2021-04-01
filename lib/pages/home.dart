import 'package:flutter/material.dart';
import 'package:pemrograman_mobile_uts/database/dbhelper.dart';
import 'package:pemrograman_mobile_uts/models/category.dart';
import 'package:pemrograman_mobile_uts/pages/task.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async'; //pendukung program asinkron

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
    return Scaffold(
      appBar: AppBar(title: Text("List Today")),
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
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.shopping_cart_rounded),
            ),
            title: Text(
              this.categoryList[index].categoryName,
              style: textStyle,
            ),
            subtitle: Text("- "),
            trailing: GestureDetector(
              child: Icon(Icons.edit),
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
