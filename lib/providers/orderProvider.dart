import 'dart:convert';
import 'package:chaabra/screens/OrderPlacedPage.dart';
import 'package:provider/provider.dart';
import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/DeliveryAddresss.dart';
import 'package:chaabra/models/userModel.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'cartProvider.dart';
import 'package:chaabra/models/Cart.dart';

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
    setNameInAddressForm();
    getZones();
  }

  CallApi callApi = CallApi();

  final postAddress = TextEditingController();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  final company = TextEditingController();
  final phone = TextEditingController();
  final postalCode = TextEditingController();


  Country selectedCountry;
  String country;
  String state;



  setNameInAddressForm()async{
    User user = await User().localUserData();
    firstName = TextEditingController(text: user == null ? "" : user.firstName);
    lastName = TextEditingController(text: user == null ? "" : user.lastName);
  }

  int selectedAddressId;

  addThisAddress(context)async{
    User user = await User().localUserData();
    final data = {
      "customer_id": user.id.toString(),
      "firstname": firstName.text,
      "lastname": lastName.text,
      "address_1" : postAddress.text,
      "country_id" : "17",
      "zone_id" : zone.zoneId.toString(),
    };


    print(data);

    showCircularProgressIndicator(context);

   final res = await callApi.postWithConnectionCheck(context,apiUrl: "shipping/address",data: data);
   final jsonRes = jsonDecode(res.body);
   if(jsonRes['response'] == "success"){
      deliveryAddress.add(DeliveryAddress.fromJson(jsonRes['address']));
      notifyListeners();
      navPop(context);
      navPop(context);
   }
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
      print(item.id);
      if(item.id == delAdd.id){
        item.selectState = true;
        selectedAddressId = item.id;
      }else{
        item.selectState = false;
      }
      notifyListeners();
    });
  }

  final List<DeliveryAddress> deliveryAddress = [];

  bool isShippingAddressLoading = false;

  fetchUserShippingAddress(context,{bool pop = false})async{
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
      if(pop == true){
        navPop(context);
      }
      isShippingAddressLoading = false;
      notifyListeners();
    } else {
      isShippingAddressLoading = false;
      notifyListeners();
    }
  }

  List<Zone> zones = [];

  Zone zone;

  bool isZoneLoading = true;

  getZones()async{
    zones.length == 0 ? isZoneLoading = true : isZoneLoading = false;
    final res = await callApi.get("zones");
    final data = jsonDecode(res.body) as List;
    if (data.length != zones.length) {
      isZoneLoading = true;
      zones.clear();
      for (Map i in data) {
        zones.add(Zone.fromJson(i));
      }
      isZoneLoading = false;
      notifyListeners();
    } else {
      isZoneLoading = false;
      notifyListeners();
    }
  }


  onChangeZone(context,Zone zoneItem){
    zone = zoneItem;
    notifyListeners();
    navPop(context);
  }

  deleteAddress(context,int addressId)async{
    showCircularProgressIndicator(context);
    final res = await callApi.getWithConnectionCheck("shipping/address/remove/$addressId", context);
    print(res.body);
    final jsonRes = jsonDecode(res.body);
    if(jsonRes["response"] == "success"){
      deliveryAddress.removeWhere((element) => element.id == addressId);
      notifyListeners();
      navPop(context);
    }
  }



  showZoneList(context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius(
                      radius: 15,
                    ),
                    color: Colors.white,
                  ),
                  height: screenHeight(context) * 50 / 100,
                  width: screenWidth(context),
                  child: ClipRRect(
                    borderRadius: borderRadius(
                      radius: 15,
                    ),
                    child: ListView.builder(
                        itemCount: zones.length,
                        itemBuilder: (context, i) {
                          final zoneItem = zones[i];
                          return ListTile(
                            onTap: (){
                              onChangeZone(context,zoneItem);
                            },
                            title: Text(
                              zoneItem.name,
                              style: TextStyle(
                                  color: Color(0xff979CA3), fontSize: 16),
                            ),
                          );
                        }),
                  ))
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          );
        });
  }

  order(context)async{
    showProgressIndicator(context,loadingText: "Placing order..");
    final cartProvider = Provider.of<CartProvider>(context,listen: false);
    User user = await User().localUserData();

    List<Map<String, dynamic>> cartJson = [];
    cartProvider.cart.forEach((element) {
      cartJson.add(Cart().toJson(context,element));
    });

    final data = {
      "customer_id": user.id.toString(),
      "cart": json.encode(cartJson),
      "total" : cartProvider.total.toString(),
      "address_id" : selectedAddressId == null ? "" : selectedAddressId.toString(),
    };
    final res = await callApi.postWithConnectionCheck(context,apiUrl: "order", data: data);
    final jsonRes = jsonDecode(res.body);
    if(jsonRes['response'] == "success"){
      cartProvider.clearCart();
      navPop(context);
      navPush(context, OrderPlacedPage());
    }
  }
}