import 'package:flutter/material.dart';
import 'package:moneymanager/db/category/category_db.dart';
import 'package:moneymanager/db/transactions/transaction_db.dart';
import 'package:moneymanager/models/category/category_model.dart';
import 'package:moneymanager/models/transaction/transaction_model.dart' as TransactionModel;


class ScreenaddTransaction extends StatefulWidget {
  static const routeName = 'add_transactions';
  const ScreenaddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenaddTransaction> createState() => _ScreenaddTransactionState();
}

class _ScreenaddTransactionState extends State<ScreenaddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;


  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();
  @override
  void initState() {
    _selectedCategorytype= CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child:Padding(
            padding: const EdgeInsets.all(20.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _purposeTextEditingController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Purpose',
                  ),
                ),
                TextFormField(
                  controller: _amountTextEditingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Amount',
                  ),
                ),

                TextButton.icon(
                  onPressed: () async{
                    final _selectedDateTemp = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                      DateTime.now().subtract( const Duration(days:30)),
                      lastDate: DateTime.now(),
                    );
                    if(_selectedDateTemp == null) {
                      return;
                    }else{
                      print(_selectedDateTemp.toString());
                      setState(() {
                        _selectedDate = _selectedDateTemp;
                      });

                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label:  Text(_selectedDate == null
                      ?'Select Date'
                      : _selectedDate!.toString()
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: CategoryType.income,
                          groupValue: _selectedCategorytype,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategorytype = CategoryType.income;
                              _categoryID=null;
                            });
                          },
                        ),
                        Text('Income'), // Corrected text to 'Expense'
                      ],
                    ),

                    Row(
                      children: [
                        Radio(
                          value: CategoryType.expense,
                          groupValue: _selectedCategorytype,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategorytype = CategoryType.expense;
                              _categoryID=null;
                            });

                          },
                        ),
                        Text('Expense'),
                      ],
                    ),
                  ],
                ),
                DropdownButton<String>(
                  hint: const Text('Select Category'),
                  value:_categoryID,
                  items:( _selectedCategorytype==CategoryType.income
                      ? CategoryDB().incomeCategoryListListener
                      :CategoryDB().expenseCategoryLististener)
                      .value
                      .map((e) {
                    return DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name),
                      onTap: (){
                        print(e.toString());
                        _selectedCategoryModel = e;
                      },
                    );
                  }).toList(),
                  onChanged: (selectedValue){
                    print(selectedValue);

                    setState(() {
                      _categoryID = selectedValue;
                    });

                  },
                ),
                ElevatedButton(onPressed: () {
                  addTransaction();
                },
                  child: Text('Submit'),
                ),
              ],
            ),

          ),
        ));
  }
  Future<void>addTransaction() async{
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;
    if (_purposeText.isEmpty){
      return;
    }
    if(_amountText.isEmpty){
      return;
    }
    // if(_categoryID ==null){
    //   return;
    // }
    if(_selectedDate ==null){
      return;
    }
    if(_selectedCategoryModel ==null)
    {
      return;
    }

    final _parsedAmount=double.tryParse(_amountText);
    if(_parsedAmount == null)
    {
      return;
    }


    final _model = TransactionModel.TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategorytype == CategoryType.income
          ? TransactionModel.CategoryType.income
          : TransactionModel.CategoryType.expense,
      category: _selectedCategoryModel!,
    );


    print("-----Transaction Model: $_model");

    await TransactionDB.instance.addTrasnsaction(_model);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }
}