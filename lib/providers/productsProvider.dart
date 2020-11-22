import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/productModel.dart';
import 'package:flutter/cupertino.dart';

class ProductsProvider extends ChangeNotifier{
    final List<Product> products = [];
    CallApi callApi = CallApi();

}