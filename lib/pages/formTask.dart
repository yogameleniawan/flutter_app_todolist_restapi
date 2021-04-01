import 'package:flutter/material.dart';
import 'package:pemrograman_mobile_uts/models/category.dart';
import 'package:pemrograman_mobile_uts/models/task.dart';

class FormTask extends StatefulWidget {
  final Task task;
  final int idCategory;
  FormTask(this.idCategory, this.task);

  @override
  _FormTaskState createState() => _FormTaskState(this.idCategory, this.task);
}

class _FormTaskState extends State<FormTask> {
  Task task;
  int idCategory;
  _FormTaskState(this.idCategory, this.task);
  TextEditingController taskName = TextEditingController();

  @override
  Widget build(BuildContext context) {
//kondisi
    if (task != null) {
      taskName.text = task.taskName;
      task.idCategory = idCategory;
    }
//rubah
    return Scaffold(
        appBar: AppBar(
          title: task == null ? Text('Tambah') : Text('Ubah'),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
// nama
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: taskName,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Task Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
//
                  },
                ),
              ),

// tombol button
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
// tombol simpan
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          if (task == null) {
// tambah data
                            task = Task(taskName.text, idCategory);
                          } else {
// ubah data
                            task.taskName = taskName.text;
                            task.idCategory = idCategory;
                          }
// kembali ke layar sebelumnya dengan membawa objek item
                          Navigator.pop(context, task);
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
// tombol batal
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Cancel',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
