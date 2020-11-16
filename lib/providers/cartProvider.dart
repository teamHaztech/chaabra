import 'dart:collection';
import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/Cart.dart';
import 'package:chaabra/models/ProductOptions.dart';
import 'package:chaabra/models/productModel.dart';
import 'package:chaabra/models/userModel.dart';
import 'package:chaabra/providers/landingPageProvider.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProvider extends ChangeNotifier {
    
    CartProvider(){
        countTotal(null);
    }

    CallApi callApi = CallApi();
    int productIdTemp;
    addProductInCartDb(context)async{
      if(selectedOptionJson.isNotEmpty){
        User user = await User().localUserData();
        final List<String> options = [];
        selectedOptionJson.forEach((key, value) {
          options.add(value);
        });
        final data = {
          "customer_id": user.id.toString(),
          "product_id": productIdTemp.toString(),
          "options": jsonEncode(options),
        };
        final res = await callApi.postWithConnectionCheck(context,data: data, apiUrl: "cart");
        print(res.body);
        final jsonRes = jsonDecode(res.body);
        if(jsonRes['response'] == "SUCCESS"){
          final option = jsonRes["cartData"]['option'];
          final product = jsonRes["product"];
          LinkedHashMap mappedOptions = new LinkedHashMap();
          mappedOptions =
        }
        if(jsonRes['response'] == "ALREADY_ADDED"){
            showToast("Product already added in cart");
        }
      }else{
        showToast("Select Option");
      }
    }

  final List<Cart> cart = [];
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

  removeThisProductFromCart(Cart cartItem){
    cart.removeWhere((element) => element.product.id == cartItem.product.id);
    showToast('${cartItem.product.productDetails} is removed from cart');
    refreshTotal();
    notifyListeners();
  }


  getMappedOptions(options){
    final map = new LinkedHashMap();
    var json = jsonDecode(options);
    var temp = json.toString();
    temp = temp.replaceAll("{", "");
    temp = temp.replaceAll("}", "");
    if(temp.contains(",")){
      final List<String>  split = temp.split(",");
      int i = 0;
      split.forEach((value) {
        map[i] = value;
        i++;
      });
    }else{
        map[0] = temp;
    }
    return map;
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
          final productPrice = element.product.price;
          total = double.parse((total + productPrice + (3 * productPrice / 100 )).toStringAsFixed(2));
          subTotal = double.parse(((subTotal + productPrice)).toStringAsFixed(2));
      });
      notifyListeners();
  }
  
  calculateProductTotal(Cart item,{bool clearAndCalculate = false}){
      if(clearAndCalculate == true){
          subTotal = 0.0;
          total = 0.0;
          notifyListeners();
      }
      final productPrice = item.product.price;
      total = double.parse((total + productPrice + (3 * productPrice / 100 )).toStringAsFixed(2));
      subTotal = double.parse(((subTotal + productPrice)).toStringAsFixed(2));
      notifyListeners();
  }


  hasAlreadySelectedThisOption(int id){
    return selectedOptionsMap.containsKey(id) ? true :false;
  }

  renderSelectedProductOptions(context){
    final layout = Provider.of<LandingPageProvider>(context,listen: false);
    layout.customDialogContent = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label(title: "Available options",padding: EdgeInsets.all(0)),
          SizedBox(height: 10,),
          Text(
            'Select Weight',
            style: TextStyle(fontSize: 18),
          ),
          Container(
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: productOption.option.length,
                itemBuilder: (context,i){
                  return GestureDetector(
                    onTap: (){
                      showOptionList(context, i);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: borderRadius(radius: 5),
                          color: Color(0xffF0F2F5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 14),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                hasAlreadySelectedThisOption(i) ? selectedOptionsMap[i].toString() : "Select",
                                style: TextStyle(
                                    color: Color(0xff979CA3), fontSize: 16),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 23,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
    notifyListeners();
  }

  clearSelectedOptionData(){
    selectedOptionsMap.clear();
    selectedOptionJson.clear();
    notifyListeners();
  }

  addCartDialog(context,{int productId})async{
    productIdTemp = productId;
    notifyListeners();
    final layout = Provider.of<LandingPageProvider>(context,listen: false);
    showProgressIndicator(context);
    final res = await callApi.get('product/option/$productId');
    final productJson = jsonDecode(res.body);
    productOption = ProductOption.fromJson(productJson);
    notifyListeners();
    navPop(context);
    notifyListeners();
    Future.delayed(Duration(seconds: 2));
    layout.isCustomDialogVisible = true;
    renderSelectedProductOptions(context);
    notifyListeners();
  }

  //Map data to display
  var selectedOptionsMap = new LinkedHashMap();
  //Map data to send
  var selectedOptionJson = new LinkedHashMap();



  selectProductOption(context,OptionValue value, int id) {
    final option = "${value.productOptionId}"":""${value.productOptionValueId}";

    notifyListeners();
    if(selectedOptionsMap.isEmpty){
      selectedOptionsMap[id] = value.name;
      selectedOptionJson[id] = option;
      notifyListeners();
    }else{
      if(selectedOptionsMap.containsKey(id)){
        selectedOptionsMap[id] = value.name;
        selectedOptionJson[id] = option;
        notifyListeners();
      }else{
        selectedOptionsMap[id] = value.name;
        selectedOptionJson[id] = option;
        notifyListeners();
      }
    }
    notifyListeners();
    renderSelectedProductOptions(context);
    navPop(context);
  }

  showOptionList(context, int optionId) {
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
                        itemCount: productOption.option[optionId].optionValue.length,
                        itemBuilder: (context, i) {
                          final option = productOption.option[optionId].optionValue[i];
                          return ListTile(
                            onTap: (){
                              selectProductOption(context,option,optionId);
                            },
                            title: Text(
                              option.name,
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
    notifyListeners();
  }
}
