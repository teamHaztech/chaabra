import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/Language.dart';
import 'package:chaabra/models/SharedPred.dart';
import 'package:chaabra/models/productModel.dart';
import 'package:flutter/material.dart';

class LanguageHandler extends ChangeNotifier{
  bool isLanguageDropdownShown = false;
  String languageIdKey = "current_language";
  int languageId;
  SharedPref sharedPref = SharedPref();

  CallApi callApi = CallApi();

  LanguageHandler(){
    fetchLanguages();
    setDefaultLanguage();
  }

  List<Language> languages = [];

  fetchLanguages()async {
    final res = await callApi.get('languages');
    final data = jsonDecode(res.body) as List;
    if (data.length != languages.length) {
      for (Map i in data) {
        languages.add(Language.fromJson(i));
      }
    }
    print(languages.length);
  }


  setDefaultLanguage()async{
    final lang = await sharedPref.read(languageIdKey);
    if(lang == null){
      sharedPref.save(languageIdKey, "en");
    }else{
      lang == "ar" ? changeLanguageToArabic(2) : changeLanguageToEnglish(1);
    }
    print(lang);
  }

  showLanguageDropdown(){
    isLanguageDropdownShown = true;
    notifyListeners();
  }

  hideLanguageDropdown(){
    isLanguageDropdownShown = false;
    notifyListeners();
  }

  changeLanguageToEnglish(int id){
      languageId = id;
      sharedPref.save(languageIdKey, id.toString());
      notifyListeners();
  }

  changeLanguageToArabic(int id){
    languageId = id;
    sharedPref.save(languageIdKey, id.toString());

    notifyListeners();
  }

  isLanguageEnglish(){
    if(languageId == null || languageId == 1){
      return true;
    }else{
      return false;
    }
  }

  ProductDetails checkLanguageAndGetProductDetails(List<ProductDetails> productDetailsList){
      ProductDetails productDetails;
      productDetailsList.forEach((element) {
        if(element.languageId == languageId){
          productDetails = element;
        }
      });
      return productDetails;
  }
}