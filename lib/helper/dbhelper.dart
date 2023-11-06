import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/model/student.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper dbHelper = DBHelper._();

  Database? database;

  Future<Database?> initDB() async {
    String path = await getDatabasesPath();

    String dbPath = join(path, 'student.db');

    database = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, _) async {
      String sql =
          'CREATE TABLE IF NOT EXISTS Student(name TEXT, grid INTEGER, contact TEXT, age INTEGER);';

      await db.execute(sql);
    });

    return database;
  }

  Future<void> insertStudentData(
      String name, int grid, String contact, int age) async {
    database = await initDB();

    String sql = 'INSERT INTO Student VALUES(?,?,?,?);';

    List args = [name, grid, contact, age];

    await database!.rawInsert(sql, args).then((val) {
      Get.snackbar('Student No: $val', 'Student data inserted...');
    });
  }

  Future<List<Student>> fetchStudentData() async {
    database = await initDB();

    String sql = 'SELECT * FROM Student;';

    List<Map<String, dynamic>> data = await database!.rawQuery(sql);

    List<Student> fetchData = data
        .map((e) => Student(
              name: e['name'],
              grid: e['grid'],
              contact: e['contact'],
              age: e['age'],
            ))
        .toList();

    return fetchData;
  }

  Future<void> deleteStudentData(int grid) async {
    database = await initDB();

    String sql = 'DELETE FROM Student WHERE grid=?';

    List args = [grid];

    await database!.rawDelete(sql, args).then((value) {
      Get.snackbar('Delete', 'Student Data Deleted',
          backgroundColor: Colors.red.shade200.withOpacity(0.5),
          snackPosition: SnackPosition.BOTTOM);
    });
  }
}
