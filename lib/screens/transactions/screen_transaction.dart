import 'package:flutter/material.dart';
import 'package:moneymanager/db/category/category_db.dart';
//import 'package:moneymanager/models/category/category_model.dart'as category;
import 'package:moneymanager/db/transactions/transaction_db.dart';
import 'package:moneymanager/models/transaction/transaction_model.dart';
import 'package:intl/intl.dart';

class ScreenTransactions extends StatelessWidget {
  const ScreenTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionListNotifier,
        builder: (BuildContext ctx, List<TransactionModel>newList, Widget?_){
          return ListView.separated(
            padding: const EdgeInsets.all(10),
            ///values
            itemBuilder: (ctx,index) {
              final _value = newList[index];
              return Card(
                elevation: 0,
                child:ListTile(
                  leading: CircleAvatar(
                    radius: 50,
                    child:Text(parseDate(_value.date),
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: _value.type == CategoryType.income
                    ? Colors.green
                        :Colors.red,
                  ),
                  title: Text('RS ${_value.amount}'),
                  subtitle: Text(_value.category.name),
                ),
              );
            },
            separatorBuilder: (ctx,index) {
              return const SizedBox(height: 10);
            },
            itemCount: newList.length,
          );
        },
    );
  }
  String parseDate(DateTime date){
    final _date = DateFormat.MMMd().format(date);
    final _splitDate = _date.split(' ');
    return '${_splitDate.last}\n${_splitDate.first}';

    //return '${date.day}\n${date.month}';


  }
}
