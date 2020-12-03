import 'package:chaabra/models/SharedPred.dart';
import 'package:flutter/material.dart';

class LanguageHandler extends ChangeNotifier{
  bool isLanguageDropdownShown = false;
  String localLanguageKey = "current_language";
  String language;
  SharedPref sharedPref = SharedPref();

  LanguageHandler(){
    // sharedPref.remove(localLanguageKey);
    setDefaultLanguage();
  }

  setDefaultLanguage()async{
    final lang = await sharedPref.read(localLanguageKey);
    if(lang == null){
      sharedPref.save(localLanguageKey, "en");
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
      sharedPref.save(localLanguageKey, "en");
      notifyListeners();
  }

  changeLanguageToArabic(){
    language = "ar";
    sharedPref.save(localLanguageKey, "ar");
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