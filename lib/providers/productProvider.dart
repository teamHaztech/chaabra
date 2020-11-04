import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/ProductOptions.dart';
import 'package:chaabra/models/productModel.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';


class SelectedOption{
  final int id;
  String name;
  SelectedOption({this.name,this.id});
}

class ProductProvider extends ChangeNotifier {
  ProductOption productOption;
  CallApi callApi = CallApi();

  ProductProvider() {
    fetchProductDetails(50);
  }

  fetchProductDetails(int productId) async {
    final res = await callApi.get('product/option/$productId');
    final productJson = jsonDecode(res.body);
    productOption = ProductOption.fromJson(productJson);
    print(productOption.product.productDetails.description);
    notifyListeners();
  }


  List<SelectedOption> selectedOptions = [];

  selectProductOption(context,OptionValue value, int id) {
      if(selectedOptions.isEmpty){
        selectedOptions.add(SelectedOption(id: id, name: value.name));
      }else{
        selectedOptions.forEach((option) {
          if(option.id == id){
            option.name = value.name;
          }else{
            selectedOptions.add(SelectedOption(id: id, name: value.name));
          }
        });
      }
      notifyListeners();
      navPop(context);
      print(selectedOptions.length);
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
