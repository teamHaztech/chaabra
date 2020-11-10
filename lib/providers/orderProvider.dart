import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/DeliveryAddresss.dart';
import 'package:chaabra/models/userModel.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';


class Country {
  final String dialCode;
  final String name;
  final String code;

  Country({this.name,this.code,this.dialCode});

  factory Country.fromJson(Map<String, dynamic> json){
    return Country(
      dialCode: json['dial_code'],
      name: json['name'],
      code: json['code'],
    );
  }
}

class OrderProvider extends ChangeNotifier{


  OrderProvider(){
    fetchUserShippingAddress(context);
  }
  CallApi callApi = CallApi();

  final postAddress = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final company = TextEditingController();
  final phone = TextEditingController();
  final postalCode = TextEditingController();


  Country selectedCountry;


  String country;
  String state;

  int selectedDeliverAddress;

  addThisAddress(context){
    final address = DeliveryAddress(
      firstname: firstName.text,
      lastname: lastName.text,
      company: company.text,
      postcode: postalCode.text,
    );
    deliveryAddress.add(address);
    navPop(context);
    notifyListeners();
  }

  selectCountry(value){
    print(jsonEncode(value.toString()));
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
          deliveryAddress.add(DeliveryAddress.fromJson(i));
      }
      isShippingAddressLoading = false;
      notifyListeners();
    } else {
      isShippingAddressLoading = false;
      notifyListeners();
    }
  }

}