import 'package:flutter/material.dart';
import 'package:moneymanager/db/category/category_db.dart';
import 'package:moneymanager/models/category/category_model.dart';
import 'package:moneymanager/screens/add_transaction/screen_add_transaction.dart';
import 'package:moneymanager/screens/category/category_add_popup.dart';
import 'package:moneymanager/screens/category/screen_category.dart';
import 'package:moneymanager/screens/home/widgets/bottom_navigation.dart';
import 'package:moneymanager/screens/transactions/screen_transaction.dart';



class Screenhome extends StatelessWidget {
  const Screenhome({super.key});

  static ValueNotifier<int> selectedIndexNotifier=ValueNotifier(0);

  final _pages= const [
    ScreenTransactions(),
    ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text('MONEY MANAGER'),
        centerTitle: true,
      ),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndexNotifier,
        builder: (BuildContext,int updatedIndex,_){
            return _pages[updatedIndex];
        }
          ,)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexNotifier.value ==0){
          print('add Transaction');
          Navigator.of(context).pushNamed(ScreenaddTransaction.routeName);
        }else{
             print('add Category');

             showCategoryAddPopup(context);
            // final _sample = CategoryModel(
            //     id: DateTime.now().millisecondsSinceEpoch.toString(),
            //     name: 'Travel',
            //     type: CategoryType.expense,
            // );
            // CategoryDB().insertCategory(_sample);
          }
          },
        child: Icon(Icons.add),
      ),
    );
  }
}
