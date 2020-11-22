import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/productModel.dart';
import 'package:chaabra/models/searchModel.dart';
import 'package:chaabra/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

class ProductsProvider extends ChangeNotifier{
    final List<Product> products = [];
    CallApi callApi = CallApi();

    
    
    ProductsProvider(){
        printUserId();
    }
    final keyword = TextEditingController();
    
    bool isTemporaryDataLoading = false;
    List<SearchData> temporarySearchedList = [];

    
    List<SearchData> searchedProductList = [];
    
    bool showSearchDropdown = false;
    
    printUserId()async{
        User user = await User().localUserData();
        print(user.id);
    }
    
    getTemporarySearchedData(key)async{
        if(keyword.text.isNotEmpty){
            showSearchDropdown = true;
            temporarySearchedList.clear();
            isTemporaryDataLoading = true;
            notifyListeners();
            final res = await callApi.getWithConnectionCheck("products/search/$key", context);
            final data = jsonDecode(res.body);
            print(data);
            for(Map json in data){
                temporarySearchedList.add(SearchData.fromJson(json));
            }
            notifyListeners();
            isTemporaryDataLoading = false;
        }else{
            showSearchDropdown = false;
            temporarySearchedList.clear();
            notifyListeners();
        }
    }
    
    bool isSearching = false;
    
    searchProducts()async{
        showSearchDropdown = false;
        searchedProductList.clear();
        notifyListeners();
        isSearching = true;
        await Future.delayed(Duration(seconds: 3));
        temporarySearchedList.forEach((element) {
            searchedProductList.add(element);
        });
        isSearching = false;
        notifyListeners();
        temporarySearchedList.clear();
    }
    
    clearSearchedData(){
        temporarySearchedList.clear();
        searchedProductList.clear();
        showSearchDropdown = false;
        keyword.clear();
        notifyListeners();
    }
    
}