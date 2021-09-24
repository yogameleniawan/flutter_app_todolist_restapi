import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pemrograman_mobile_uts/models/category.dart';
import 'package:pemrograman_mobile_uts/models/task.dart';

class HTTPService {
  Client client = Client();
  final String baseUrl = "https://rest-api-tumbas.herokuapp.com";

  Future<List> getTask({String category_id}) async {
    final String uri =
        "https://rest-api-tumbas.herokuapp.com/api/v1/task/" + category_id;

    http.Response result = await http.get(Uri.parse(uri));
    if (result.statusCode == HttpStatus.ok) {
      print("Sukses");
      final jsonResponse = json.decode(result.body);
      final tasksMap = jsonResponse['data'];
      List tasks = tasksMap.map((i) => Task.fromJson(i)).toList();
      return tasks;
    } else {
      print("Fail");
      return null;
    }
  }

  Future<List> getCategory() async {
    final String uri = "https://rest-api-tumbas.herokuapp.com/api/v1/category";

    http.Response result = await http.get(Uri.parse(uri));
    if (result.statusCode == HttpStatus.ok) {
      print("Sukses");
      final jsonResponse = json.decode(result.body);
      final categoryMap = jsonResponse['data'];
      List category = categoryMap.map((i) => Category.fromJson(i)).toList();
      return category;
    } else {
      print("Fail");
      return null;
    }
  }

  Future createCategory(String name, String icon) async {
    try {
      http.Response hasil = await http.post(
          Uri.parse("https://rest-api-tumbas.herokuapp.com/api/v1/category"),
          body: {
            'name': name,
            'icon': icon
          },
          headers: {
            "Accept": "application/json",
          });
      if (hasil.statusCode == 200) {
        print("status 200");
        return true;
      } else if (hasil.statusCode == 201) {
        return true;
      } else {
        print("error status " + hasil.statusCode.toString());
        return null;
      }
    } catch (e) {
      print("error catchnya $e");
      return null;
    }
  }
}
