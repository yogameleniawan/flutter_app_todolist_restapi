import 'package:flutter/material.dart';
import 'package:pemrograman_mobile_uts/models/category.dart';

class EntryForm extends StatefulWidget {
  final Category category;
  EntryForm(this.category);
  @override
  EntryFormState createState() => EntryFormState(this.category);
}

//class controller
class EntryFormState extends State<EntryForm> {
  Category category;
  EntryFormState(this.category);
  TextEditingController categoryName = TextEditingController();

  @override
  Widget build(BuildContext context) {
//kondisi
    if (category != null) {
      categoryName.text = category.categoryName;
    }
//rubah
    return Scaffold(
        appBar: AppBar(
          title: category == null ? Text('Tambah') : Text('Ubah'),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
// nama
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: categoryName,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
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
                          if (category == null) {
// tambah data
                            category = Category(
                              categoryName.text,
                            );
                          } else {
// ubah data
                            category.categoryName = categoryName.text;
                          }
// kembali ke layar sebelumnya dengan membawa objek item
                          Navigator.pop(context, category);
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
