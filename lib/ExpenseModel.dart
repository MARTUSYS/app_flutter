import 'package:appflutter/DataB.dart';
import 'package:date_format/date_format.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Expense.dart';

class ExpensesModel extends Model {
  List<Expense> _item = [
    Expense(1, DateTime.now(), "---", 111),
    Expense(2, DateTime.now(), "---", 222),
  ];
  DataB _database;

  int _year = DateTime.now().year;
  int _month = DateTime.now().month;

  double sum_ = 0;

  int get recordsCount => _item.length;

  ExpensesModel() {
    _database = DataB();
    Load_month(_month, _year);
  }

//  void Load() {
//    Future<List<Expense>> future = _database.getGetAllExpenses();
//    future.then((list) {
//      _item = list;
//      Sum_();
//  notifyListeners();
//  });
//  }

  void Load_month(int month, int year) {
    Future<List<Expense>> future = _database.getGetAllExpenses_month(month, year);
    future.then((list) {
      _month = month;
      _year = year;
      _item = list;
      Sum();
      notifyListeners();
    });
  }

  void Sum() {
    sum_ = 0;
    for (var i in _item) {
      sum_ += i.price;
    }
  }

  String GetKey(int index) {
    return _item[index].id.toString();
  }

  Expense GetAll(int index) {
    return _item[index];
  }

  String GetText(int index) {
    var e = _item[index];
    return e.name + " for " + e.price.toString() + " RUB" + "\n" + formatDate(e.date, [d, '-', M, '-',yyyy , ' ', HH, ':', nn, ':', ss]);
  }

  void removeAt(int index) {
    Future<void> future = _database.delExpenses(_item[index].id);
    future.then((_) {
      Load_month(_month, _year);
    });
  }

  void AddExpense(String name, double price, DateTime date) {
    Future<void> future = _database.addExpenses(name, price, date);
    future.then((_) {
      Load_month(_month, _year);
    });
  }

  void UpExpense(int index, String name, double price, DateTime date) {
    Future<void> future = _database.upExpenses(_item[index].id, name, price, date);
    future.then((_) {
      Load_month(_month, _year);
    });
  }
}