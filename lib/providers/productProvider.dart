import 'dart:collection';
import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/ProductOptions.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaabra/providers/cartProvider.dart';


class SelectedOption{
  int id;
  String name;
  SelectedOption({this.name,this.id});
}

class ProductProvider extends ChangeNotifier {
  CallApi callApi = CallApi();

  addThisProductCart(context){
    final cart = Provider.of<CartProvider>(context,listen: false);
    cart.addThisProductInServerCart(context);
  }

}
