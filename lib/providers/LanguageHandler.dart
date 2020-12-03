import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/Language.dart';
import 'package:chaabra/models/SharedPred.dart';
import 'package:flutter/material.dart';

class LanguageHandler extends ChangeNotifier{
  bool isLanguageDropdownShown = false;
  String languageId = "current_language";
  String language;
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
    final lang = await sharedPref.read(languageId);
    if(lang == null){
      sharedPref.save(languageId, "en");
    }else{
      lang == "ar" ? changeLanguageToArabic() : changeLanguageToEnglish();
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

  changeLanguageToEnglish(){
      language = "en";
      sharedPref.save(languageId, "en");
      notifyListeners();
  }

  changeLanguageToArabic(){
    language = "ar";
    sharedPref.save(languageId, "ar");
    notifyListeners();
  }

  isLanguageEnglish(){
    if(language == null || language == "en"){
      return true;
    }else{
      return false;
    }
  }

}