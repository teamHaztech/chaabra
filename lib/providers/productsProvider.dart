import 'package:path/path.dart';
import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/productModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:chaabra/staticData.dart';

class ProductsProvider extends ChangeNotifier{

    
    final List<Product> products = [];
    CallApi callApi = CallApi();
    
    where({String matchCase, List<Product> productList}){
        products.clear();
        productList.forEach((p) {
            if(p.type == matchCase){
                products.add(p);
            }
        });
    }
    
}