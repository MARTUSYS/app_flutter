import 'package:appflutter/ExpenseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_formfield/flutter_datetime_formfield.dart';

class _AddExpenseState extends State<AddExpense>{
  double _price;
  String _name;
  DateTime _date;

  bool _flag;
  int _index;

  ExpensesModel _model;
  GlobalKey<FormState> _foraKey = GlobalKey<FormState>();

  _AddExpenseState(this._model, this._index, this._flag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(initial_Title(_flag)),),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _foraKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  icon: Icon(Icons.shopping_basket),
                ),
                initialValue: initial_Name(_flag, _index, _model), /// //////////
                onSaved: (value) {
                  _name = value;
                  if (value == ""){
                    _name = "Unknown";
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Price (RUB)",
                  icon: Icon(Icons.attach_money),
                ),
                autovalidate: true,
                initialValue: initial_Price(_flag, _index, _model),/// ////////////
                keyboardType: TextInputType.number,
                validator: (value){
                  if (double.tryParse(value) != null) {
                    return null;
                  } else {
                    return "Enter the valid price";
                  }
                },
                onSaved: (value) {
                  _price = double.tryParse(value);
                },
              ),
              SizedBox(
                height: 30,
              ),
              DateTimeFormField(
                initialValue: initial_Time(_flag, _index, _model),
                label: "Time",
                validator: (value) {
                  if (value != null){
                    return null;
                  } else{
                    return "Enter the valid time";
                  }
                },
                onSaved: (value){
                  _date = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
//                color: Colors.amber[100],
                highlightColor: Colors.amber[200],
                splashColor: Colors.amberAccent[100],
                onPressed: () {
                  if (_foraKey.currentState.validate()) {
                    _foraKey.currentState.save();
                    if (_flag)
                      _model.UpExpense(_index, _name, _price, _date);
                    else
                      _model.AddExpense(_name, _price, _date);

                    Navigator.pop(context);
                  }
                },
                child: Text(initial_Button(_flag),
                  style: TextStyle(
                    color: Colors.amber,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String initial_Name(bool _flag, int _index, ExpensesModel _model) {
  if (_flag)
    return _model.GetAll(_index).name;
  else
    return "";
}

String initial_Price(bool _flag, int _index, ExpensesModel _model) {
  if (_flag)
    return _model.GetAll(_index).price.toString();
  else
    return "0";
}

DateTime initial_Time(bool _flag, int _index, ExpensesModel _model) {
  if (_flag)
    return _model.GetAll(_index).date;
  else
    return DateTime.now();
}

String initial_Title(bool _flag){
  if (_flag)
    return "Editing";
  else
    return "Add Expense";
}

String initial_Button(bool _flag){
  if (_flag)
    return "Edit";
  else
    return "Add";
}

class AddExpense extends StatefulWidget{
  final ExpensesModel _model;
  final int _index;
  final bool _flag; /// Если редактирование
  AddExpense(this._model, this._index, this._flag);

  @override
  State<StatefulWidget> createState() => _AddExpenseState(_model, _index, _flag);
}