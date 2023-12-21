import 'package:flutter/material.dart';

import '../../models/category/category_model.dart';
import 'package:moneymanager/db/category/category_db.dart';


class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB().incomeCategoryListListener,
        builder: (BuildContext ctx,List<CategoryModel>newlIst,Widget?_){
          return ListView.separated(
            itemBuilder: (ctx,index) {
              final category = newlIst[index];
              return Card(
                child:ListTile(
                  title:Text(category.name),
                  trailing: IconButton(
                    onPressed: () {
                      CategoryDB.instance.deleteCategory(category.id);
                    },

                    icon: const  Icon(Icons.delete),
                  ),
                ),
              );
            },
            separatorBuilder: (ctx,index) {
              return const SizedBox(height: 10);
            },
            itemCount: newlIst.length,
          );
        });
  }
}
