import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/CategoryModel.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';


class CategoryProvider extends ChangeNotifier {
  final List<CategoryModel> categories = [];

  CallApi callApi = CallApi();

  bool isCategoriesLoading = true;
  fetchCategories() async {
    categories.length == 0
        ? isCategoriesLoading = true
        : isCategoriesLoading = false;
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
  List<CategoryProduct> categoryProductsTemp = [];
  bool isCategoryProductsLoading = false;
  fetchCategoryProduct(CategoryModel category) async {
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
        categoryProductsTemp.add(CategoryProduct.fromJson(i));
      }
      isCategoryProductsLoading = false;
      notifyListeners();
    } else {
      isCategoryProductsLoading = false;
      notifyListeners();
    }
  }

  double rangeMin = 0;
  double rangeMax = 3;

  double selectedRangeMin = 1;
  double selectedRangeMax = 3;

  bool isFilterShow = true;
  
  onChangePriceRange(min,max){
    selectedRangeMax = max;
    selectedRangeMin = min;
    notifyListeners();
  }
  
  toggleFilter(){
    print("toggled");
    if(isFilterShow == true){
      isFilterShow = false;
    }else{
      isFilterShow = true;
    }
    notifyListeners();
  }

  
  
  applyFilter(context, int categoryId)async{
    final minPrice = selectedRangeMin.round();
    final maxPrice = selectedRangeMax.round();
    final priceRange = {"minPrice": minPrice.toString(),"maxPrice": maxPrice.toString()};
    
    final data = {
      "priceRange": jsonEncode(priceRange),
      "sort": "",
      "categoryId": categoryId.toString(),
      "isInStock": isInStock.toString(),
    };
    isCategoryProductsLoading = true;
    notifyListeners();
    final res = await callApi.postWithConnectionCheck(context,data: data, apiUrl: "products/filter");
    print(res.body);
    final json = jsonDecode(res.body) as List;
    categoryProducts.clear();
    notifyListeners();
    for (Map i in json) {
      categoryProducts.add(CategoryProduct.fromJson(i));
    }
    isCategoryProductsLoading = false;
    notifyListeners();
  }
  
  bool isInStock = false;
  
  toggleAvailability(value){
    isInStock == true ? isInStock = false : isInStock = true;
    notifyListeners();
  }
}

class Price{
  getMaxPrice(List<CategoryProduct> categoryProducts){
    List<double> price = [];
    categoryProducts.forEach((element) { 
      price.add(element.product.price);
    });
    price.sort();
    return price.last;
  }
  
  getMinPrice(List<CategoryProduct> categoryProducts){
    List<double> price = [];
    categoryProducts.forEach((element) {
      price.add(element.product.price);
    });
    price.sort();
    return price.first;
  }
}
