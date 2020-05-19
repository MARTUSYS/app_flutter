import 'dart:io';
import 'package:appflutter/Expense.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataB {
  Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initialize();
    }
    return _database;
  }

  DataB() {}

  initialize() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    var path = join(documentsDir.path, "db.db");
    return openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE Expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, price REAL, date TEXT, name TEXT, month INTEGER, year INTEGER)");
      }
    );
  }

//  Future<List<Expense>> getGetAllExpenses() async{
//    Database db = await database;
//    List<Map> query = await db.rawQuery("SELECT * FROM Expenses ORDER BY date DESC"); /// добавить запрос на месяц
//    var result = List<Expense>();
//    query.forEach((i) => result.add(Expense(i["id"], DateTime.parse(i["date"]), i["name"], i["price"])));
//    return result;
//  }

  Future<List<Expense>> getGetAllExpenses_month(int month, int year) async{
    Database db = await database;
    List<Map> query = await db.rawQuery("SELECT id, name, date, price FROM Expenses WHERE month = $month and year = $year ORDER BY date DESC");
    var result = List<Expense>();
    query.forEach((i) => result.add(Expense(i["id"], DateTime.parse(i["date"]), i["name"], i["price"])));
    return result;
  }

  Future<void> addExpenses(String name, double price, DateTime dateTime) async {
    Database db = await database;
    var dtStr = dateTime.toString();
    var month = dateTime.month;
    var year = dateTime.year;
    await db.rawInsert("INSERT INTO Expenses (name, date, price, month, year) VALUES (\"$name\", \"$dtStr\", $price, $month, $year)");
  }

  Future<void> delExpenses(int id) async {
    Database db = await database;
    await db.rawDelete("DELETE FROM Expenses WHERE id = $id");
  }

  Future<void> upExpenses(int id, String name, double price, DateTime dateTime) async {
    Database db = await database;
    var dtStr = dateTime.toString();
    var month = dateTime.month;
    var year = dateTime.year;
    await db.rawUpdate("UPDATE Expenses SET name = \"$name\", date = \"$dtStr\", price = $price, month = $month, year = $year WHERE id = $id");
  }
}