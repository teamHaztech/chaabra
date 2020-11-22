import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/productModel.dart';
import 'package:chaabra/models/searchModel.dart';
import 'package:chaabra/staticData.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

class ProductsProvider extends ChangeNotifier{
    final List<Product> products = [];
    CallApi callApi = CallApi();

    final keyword = TextEditingController();

    ProductsProvider(){
        getBasicProductDetails(context);
    }
    
    List<SearchData> productSearchingList = [];
    
    List<SearchData> searchedResponse = [];

    searchProducts(keyword)async{
        
        searchedResponse.clear();
        productSearchingList.forEach((element) {
            final name = element.name.toLowerCase();
            if(name.contains(keyword.toString().toLowerCase())){
                searchedResponse.add(element);
            }
            notifyListeners();
        });
        print(searchedResponse);
    }
    
    
    getBasicProductDetails(context)async{
//        final res = await callApi.getWithConnectionCheck("products/basic-details", context);
//        final data = jsonDecode(res.body) as List;
//        productSearchingList.clear();
        for (Map i in searchedProduct) {
            productSearchingList.add(SearchData.fromJson(i));
        }
        notifyListeners();
        print(productSearchingList.length);
    }
}