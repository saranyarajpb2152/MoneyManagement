import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneymanager/models/transaction/transaction_model.dart';
import 'package:moneymanager/models/category/category_model.dart';



const TRANSACTION_DB_NAME ='transaction-db';


abstract class TransactionDbFunctions{
  Future<void> addTrasnsaction(TransactionModel obj);
  Future<List<TransactionModel>>getAllTransactions();
}
class TransactionDB implements TransactionDbFunctions{
  TransactionDB._internal();

  static TransactionDB  instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
  ValueNotifier([]);



  @override
  Future<void> addTrasnsaction(TransactionModel obj)async {
    final _db = await Hive.openBox(TRANSACTION_DB_NAME);
    await _db.put(obj.id, obj);
  }
  Future<void> refresh() async {
    final _list = await getAllTransactions();
    _list.sort((first,second)=> second.date.compareTo(first.date));
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_list);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions()async {
    final _db =await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _db.values.toList();
  }

}