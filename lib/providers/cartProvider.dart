import 'dart:collection';
import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/Cart.dart';
import 'package:chaabra/models/ProductOptions.dart';
import 'package:chaabra/models/userModel.dart';
import 'package:chaabra/providers/landingPageProvider.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

class CartProvider extends ChangeNotifier {

    CartProvider(){
        countTotal(null);
        fetchCartData(context);
        fetchProductOptions(157);
    }

    clearProductData(){
      productOption = null;
      selectedOptionsMap.clear();
    }

    CallApi callApi = CallApi();
    int productIdTemp;



    getProductTotalInCart(int productId){
      double total = 0;
      cart.forEach((cartItem) {
        if(cartItem.product.id == productId){
          var productPrice = 0.0;
          int i = 0;
          cartItem.selectedOption.forEach((e) {
            productPrice  += (i == 0 ? cartItem.product.price : 0) + e.price;
            i++;
          });
          total = double.parse((total + productPrice).toStringAsFixed(2));
        }
      });
      return total.toString();
    }

    bool isCartLoading = false;

    fetchCartData(context)async{
      User user = await User().localUserData();
      cart.length == 0 ? isCartLoading = true : isCartLoading = false;
      notifyListeners();
      final res = await callApi.getWithConnectionCheck("cart/${user.id}", context);
      final data = jsonDecode(res.body) as List;
      if (data.length != cart.length) {
        isCartLoading = true;
        cart.clear();
        for (Map i in data) {
          cart.add(Cart.fromJson(i));
        }
        isCartLoading = false;
        notifyListeners();
      } else {
        isCartLoading = false;
        notifyListeners();
      }
      refreshTotal();
    }

    final List<Cart> cart = [];

    deletingCartItemIndicator(Cart cartItem){
      cart.forEach((element) {
        element.id == cartItem.id ? element.isRemoving = true : element.isRemoving = false;
        notifyListeners();
      });
    }

    clearCart(){
          cart.clear();
          total = 0.0;
          subTotal = 0.0;
          notifyListeners();
    }


    fetchProductOptions(int productId) async {
      final res = await callApi.get('product/option/$productId');
      final productJson = jsonDecode(res.body);
      productOption = ProductOption.fromJson(productJson);
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

    addThisProductInServerCart(context)async{
      final layout = Provider.of<LandingPageProvider>(context,listen: false);
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
        showCircularProgressIndicator(context);
        final res = await callApi.postWithConnectionCheck(context,data: data, apiUrl: "cart");
        final jsonRes = jsonDecode(res.body);
        if(jsonRes['response'] == "SUCCESS"){
          final cartData = jsonRes["cartData"];
          addThisProductInCartLocally(Cart.fromJson(cartData));
          layout.closeCustomDialog();
          navPop(context);
          notifyListeners();
        }
        if(jsonRes['response'] == "ALREADY_ADDED"){
          layout.closeCustomDialog();
          showToast("Product already added in cart");
          navPop(context);
        }
      }else{
        showToast("Select Option");
      }
    }


    removeThisProductFromServerCart(context,Cart cartItem)async{
      deletingCartItemIndicator(cartItem);
      final data = {
        "cart_id": cartItem.id.toString(),
      };
      final res = await callApi.postWithConnectionCheck(context,apiUrl: "cart/remove",data: data);
      final jsonRes = jsonDecode(res.body);
      if(jsonRes['response'] == "SUCCESS"){
        removeThisProductFromCartLocally(cartItem);
      }
    }

    addThisProductInCartLocally(Cart cartItem) {
      if (_cartModel.cartHasThisProduct(cartItem: cartItem, cartList: cart)) {
        showToast('${cartItem.product.productDetails.name} already added in cart');
      } else {
        cart.add(cartItem);
        refreshTotal();
        showToast('${cartItem.product.productDetails.name} added in cart');
        notifyListeners();
      }
    }

    removeThisProductFromCartLocally(Cart cartItem){
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



    removeNonNumericCh(String weight){
        final w = weight.split(" ");
        return w[0];

    }


    refreshTotal(){
        subTotal = 0.0;
        total = 0.0;
        cart.forEach((element) {
          var productPrice = 0.0;
            int i = 0;
            element.selectedOption.forEach((e) {
              productPrice += (i == 0 ? element.product.price : 0) + e.price;
              i++;
            });
            total = double.parse((total + productPrice).toStringAsFixed(3));
            subTotal = double.parse(((subTotal + productPrice)).toStringAsFixed(3));
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


    setTempProductId(int productId){
      productIdTemp = productId;
      notifyListeners();
    }


    addCartDialog(context,{int productId,bool showLoader = false})async{
      print(productId);
      setTempProductId(productId);
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
