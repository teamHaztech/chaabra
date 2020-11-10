import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/Cart.dart';
import 'package:chaabra/models/DeliveryAddresss.dart';
import 'package:chaabra/models/ProductOptions.dart';
import 'package:chaabra/models/userModel.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class CartProvider extends ChangeNotifier {
    
    CartProvider(){
        countTotal(null);
    }


    CallApi callApi = CallApi();


  final List<Cart> cart = [
  
  ];

    fetchProductOptions(int productId) async {
      final res = await callApi.get('product/option/$productId');
      final productJson = jsonDecode(res.body);
      productOption = ProductOption.fromJson(productJson);
      print(productOption.option.length);
      notifyListeners();
    }






    ProductOption productOption;


    
    
    List<String> countries = [
        'Bahrain',
        'India'
    ];

    List<String> states = [
        'Goa',
        'Manama',
        'Isa town'
    ];
    


  double total = 0.0;
  
  double subTotal = 0.0;
  
  double delivery = 0.0;
  
  Cart _cartModel = Cart();
  
  addThisProductInCart(Cart cartItem) {
    if (_cartModel.cartHasThisProduct(cartItem: cartItem, cartList: cart)) {
      showToast('${cartItem.product.productDetails.name} already added in cart');
    } else {
      cart.add(cartItem);
      refreshTotal();
      showToast('${cartItem.product.productDetails.name} added in cart');
      notifyListeners();
    }
  }

  increaseProductQuantity(Cart cartItem){
      cart.forEach((item) {
          if(item.product.id == cartItem.product.id){
              item.quantity ++;
              notifyListeners();
          }
      });
      countTotal(cartItem);
      User user = User().localUserData();
  }

  decreaseProductQuantity(Cart cartItem){
      cart.forEach((item) {
          if(item.product.id == cartItem.product.id){
              if(item.quantity > 1){
                  item.quantity --;
              }
              notifyListeners();
          }
      });
      refreshTotal();
  }





  
  countTotal(Cart cartItem,{bool clearAndCalculate = false}){
     if(cartItem == null){
         cart.forEach((item){
                 calculateProductTotal(item);
         });
     }else{
         cart.forEach((item){
             if(cartItem.product.id == item.product.id){
                 calculateProductTotal(item);
             }
         });
     }
  }
  
  refreshTotal(){
      subTotal = 0.0;
      total = 0.0;
      cart.forEach((element) {
          final productPrice = element.quantity * element.product.price;
          total = double.parse((total + productPrice + (3 * productPrice / 100 )).toStringAsFixed(2));
          subTotal = double.parse(((subTotal + productPrice)).toStringAsFixed(2));
      });
      notifyListeners();
  }
  
  removeThisProductFromCart(Cart cartItem){
      cart.removeWhere((element) => element.product.id == cartItem.product.id);
      showToast('${cartItem.product.productDetails} is removed from cart');
      refreshTotal();
      notifyListeners();
  }
  
  calculateProductTotal(Cart item,{bool clearAndCalculate = false}){
      if(clearAndCalculate == true){
          subTotal = 0.0;
          total = 0.0;
          notifyListeners();
      }
      final productPrice = clearAndCalculate == true ? item.quantity * item.product.price : item.product.price;
      total = double.parse((total + productPrice + (3 * productPrice / 100 )).toStringAsFixed(2));
      subTotal = double.parse(((subTotal + productPrice)).toStringAsFixed(2));
      notifyListeners();
  }
}
