import 'package:chaabra/screens/Categories.dart';
import 'package:chaabra/screens/HomePage.dart';
import 'package:chaabra/screens/Profile.dart';
import 'package:chaabra/screens/WishLIst.dart';
import 'package:flutter/material.dart';

class LandingPageProvider extends ChangeNotifier{
    int activePage = 0;
    
    List pages = [
        HomePage(),
        WishlistPage(),
        CategoryPage(),
        Profile(),
    ];
    
    setActiveTabColor(int index){
        if(index == activePage){
            return Color(0xfff0f0f0);
        }else{
            return Colors.white;
        }
    }
    
    changeNavBarPage(int index){
        activePage = index;
        notifyListeners();
    }
}