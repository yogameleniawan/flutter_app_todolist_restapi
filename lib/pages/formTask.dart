import 'package:flutter/material.dart';
import 'package:pemrograman_mobile_uts/database/httpservice.dart';
import 'package:pemrograman_mobile_uts/models/category.dart';
import 'package:pemrograman_mobile_uts/models/task.dart';

class FormTask extends StatefulWidget {
  final Task task;
  final String idCategory;
  FormTask(this.idCategory, this.task);

  @override
  _FormTaskState createState() => _FormTaskState(this.idCategory, this.task);
}

class _FormTaskState extends State<FormTask> {
  Task task;
  String idCategory;
  _FormTaskState(this.idCategory, this.task);
  TextEditingController taskName = TextEditingController();
  HTTPService service;
  @override
  void initState() {
    // TODO: implement initState
    service = new HTTPService();
    super.initState();
  }

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
                        onPressed: () async {
                          bool status = await service.updateTask(
                              task.id, taskName.text, idCategory);
                          if (status == true) {
                            print("sukses");
                          } else {
                            print("gagal");
                          }

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
