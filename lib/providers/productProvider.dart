import 'dart:collection';
import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/ProductOptions.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';


class SelectedOption{
  int id;
  String name;
  SelectedOption({this.name,this.id});
}

class ProductProvider extends ChangeNotifier {
  ProductOption productOption;
  CallApi callApi = CallApi();

  ProductProvider() {
    fetchProductDetails(157);
  }

  clearProductData(){
    productOption = null;
    selectedOptionsMap.clear();
    print(productOption);
    print(selectedOptionsMap);
  }

  fetchProductDetails(int productId) async {
    final res = await callApi.get('product/option/$productId');
    final productJson = jsonDecode(res.body);
    productOption = ProductOption.fromJson(productJson);
    print(productOption.option.length);
    notifyListeners();
  }

  var selectedOptionsMap = new LinkedHashMap();

  selectProductOption(context,OptionValue value, int id) {
      notifyListeners();
      if(selectedOptionsMap.isEmpty){
        selectedOptionsMap[id] = value.name;
        notifyListeners();
      }else{
        if(selectedOptionsMap.containsKey(id)){
          selectedOptionsMap[id] = value.name;
          notifyListeners();
        }else{
          selectedOptionsMap[id] = value.name;
          notifyListeners();
        }
      }
      selectedOptionsMap.forEach((key, value) {
        print(value);
      });
      notifyListeners();
      navPop(context);
  }

  hasAlreadySelectedThisOption(int id){
    return selectedOptionsMap.containsKey(id) ? true :false;
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
  }
}
