import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/Cart.dart';
import 'package:chaabra/models/DeliveryAddresss.dart';
import 'package:chaabra/models/userModel.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Country{
    final int id;
    final String name;
    Country({this.id,this.name});
}
class CartProvider extends ChangeNotifier {
    
    CartProvider(){
        countTotal(null);
        fetchUserShippingAddress(context);
    }


    CallApi callApi = CallApi();


  final List<Cart> cart = [
  
  ];
    
    final addressType = TextEditingController();
    final postAddress = TextEditingController();
    final fullName = TextEditingController();
    final email = TextEditingController();
    final phone = TextEditingController();
    final postalCode = TextEditingController();
    String country;
    String state;

    int selectedDeliverAddress;
    
    addThisAddress(context){
        final address = DeliveryAddress(

        );
        deliveryAddress.add(address);
        navPop(context);
        notifyListeners();
    }
    
    
    List<String> countries = [
        'Bahrain',
        'India'
    ];

    List<String> states = [
        'Goa',
        'Manama',
        'Isa town'
    ];
    
    
    selectCountry(value){
        country = value;
        notifyListeners();
    }

    selectState(value){
        state = value;
        notifyListeners();
    }
    
    selectAddress(DeliveryAddress delAdd){
        deliveryAddress.forEach((item) {
            if(item.id == delAdd.id){
                item.selectState = true;
                selectedDeliverAddress = item.id;
            }else{
                item.selectState = false;
            }
            notifyListeners();
        });
        print(selectedDeliverAddress);
    }


    final List<DeliveryAddress> deliveryAddress = [];
    bool isShippingAddressLoading = true;
    fetchUserShippingAddress(context)async{
      User user = await User().localUserData();
      deliveryAddress.length == 0 ? isShippingAddressLoading = true : isShippingAddressLoading = false;
      notifyListeners();
      final res = await callApi.getWithConnectionCheck('shipping/address/${user.id}', context);
      final data = jsonDecode(res.body) as List;
      if (data.length != deliveryAddress.length) {
        isShippingAddressLoading = true;
        deliveryAddress.clear();
        for (Map i in data) {
//          deliveryAddress.add();
        }
        isShippingAddressLoading = false;
        notifyListeners();
      } else {
        isShippingAddressLoading = false;
        notifyListeners();
      }
    }


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
