import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/CategoryModel.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier{
  final List<CategoryModel> categories = [];

  CallApi callApi = CallApi();

  bool isCategoriesLoading = true;
  fetchCategories() async {
    categories.length == 0 ? isCategoriesLoading = true : isCategoriesLoading = false;
    notifyListeners();
    final res = await callApi.get('categories');
    final data = jsonDecode(res.body) as List;
    if (data.length != categories.length) {
      isCategoriesLoading = true;
      categories.clear();
      for (Map i in data) {
        categories.add(CategoryModel.fromJson(i));
      }
      isCategoriesLoading = false;
      notifyListeners();
    } else {
      isCategoriesLoading = false;
      notifyListeners();
    }
  }

  List<CategoryProduct> categoryProducts = [];
  bool isCategoryProductsLoading = true;
  fetchCategoryProduct(CategoryModel category)async{
    categoryProducts.clear();
    notifyListeners();
    isCategoryProductsLoading = true;
    notifyListeners();
    final res = await callApi.get('category/product/${category.id}');
    final data = jsonDecode(res.body) as List;
    if (data.length != categoryProducts.length) {
      categoryProducts.clear();
      for (Map i in data) {
        categoryProducts.add(CategoryProduct.fromJson(i));
      }
      isCategoryProductsLoading = false;
      notifyListeners();
    } else {
      isCategoryProductsLoading = false;
      notifyListeners();
    }
  }


  // showFilterDialog(context){
  //   showDialog(context: context, builder: (context){
  //
  //   });
  // }

  filterCategoryProducts()async{
    // final
  }

}