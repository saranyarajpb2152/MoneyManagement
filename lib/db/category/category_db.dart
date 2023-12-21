import 'package:flutter/cupertino.dart';
import 'package:moneymanager/models/category/category_model.dart';
import 'package:hive/hive.dart';

const  CATEGORY_DB_NAME = 'category-database';

abstract class CategoryDbFunctions{
  Future<List<CategoryModel>>getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryID);
}

class CategoryDB implements CategoryDbFunctions{

  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();
  factory CategoryDB(){
    return instance;
  }



  ValueNotifier<List<CategoryModel>> incomeCategoryListListener =
  ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryLististener =
  ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value)async {

    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.put(value.id,value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>>getCategories()async{
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }
  Future<void> refreshUI() async{
    final _allCategories = await getCategories();
    incomeCategoryListListener.value.clear();
    expenseCategoryLististener.value.clear();
    await Future.forEach(_allCategories,(CategoryModel category){
      if(category.type == CategoryType.income) {
        incomeCategoryListListener.value.add(category);
      } else{
        expenseCategoryLististener.value.add(category);
      }
    },
    );
    incomeCategoryListListener.notifyListeners();
    expenseCategoryLististener.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final _categoryDB =await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.delete(categoryID);
    refreshUI();
  }
}