import 'package:appflutter/AddExpense.dart';
import 'package:appflutter/ExpenseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter expenses',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'Monthly expenses'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  final List<String> month = [
    "",  "January", "February", "March", "April", "May", "June", "July",
    "August", "September", "October", "November", "December"
    ];

//  double rating = 1;
  int year = DateTime.now().year;
  int month_ = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ExpensesModel>(
        model: ExpensesModel(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: ScopedModelDescendant<ExpensesModel>(
            builder: (context, child, model) => ListView.separated(
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      color: Colors.amber[300],
                      child: ListTile(
                        title: Center(child: Text(month[month_] + " " + year.toString() + "\n" + "Monthly expenses: " + model.sum_.toString() + " RUB")),
                        leading: IconButton(icon: Icon(
                          CupertinoIcons.back,
                          size: 35,
                        ),
                          highlightColor: Colors.white,
                          splashColor:  Colors.white,
                          onPressed: () {
                          month_ -= 1;
                          if (month_ == 0) {
                            year -= 1;
                            month_ = 12;
                          }
                          model.Load_month(month_, year);
                        },),
                        trailing: IconButton(icon: Icon(
                          CupertinoIcons.forward,
                          size: 35,
                        ),
                          highlightColor: Colors.white,
                          splashColor:  Colors.white,
                          onPressed: () {
                          month_ += 1;
                          if (month_ == 13) {
                            year += 1;
                            month_ = 1;
                          }
                          model.Load_month(month_, year);
                        },),
                      ),
                    );
                  } else {
                    index -= 1;
                    return Dismissible(
                      key: Key(model.GetKey(index)),

                      background: Container(
                        color: Colors.amberAccent,
                        child: Icon(CupertinoIcons.pencil),
                      ),
                      secondaryBackground: Container(
                          color: Colors.red[400],
                          child: Icon(CupertinoIcons.delete_simple),
                      ),
                      // ignore: missing_return
                      confirmDismiss: (direction) {
                        if (direction != DismissDirection.startToEnd) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Accept?"),
                                content: Text("Really want to delete?"),
                                actions: [
                                  FlatButton(child: Text("No"), onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },),
                                  FlatButton(child: Text("Yes"), onPressed: () {
                                    model.removeAt(index);
                                    Navigator.of(context).pop(true);
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text("Deleted record $index"),),
                                    );
                                  }
                                  ),
                                ],
                              );
                            }
                          );
                        } else {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return AddExpense(model, index, true);
                              }
                          )
                          );
                        }
                      },

                      child: ListTile(
                        title: Text(model.GetText(index)),
                        leading: Icon(CupertinoIcons.pencil),
                        trailing: Icon(CupertinoIcons.delete_simple),
                      ),
                    );
                  }
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: model.recordsCount + 1
            ),
          ),
          floatingActionButton: ScopedModelDescendant<ExpensesModel>(
            builder: (context, child, model) => FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return AddExpense(model, -1, false);
                    }
                  )
                );
              },
              child: Icon(CupertinoIcons.add),
            ),
          ),
        ),
    );
  }
}