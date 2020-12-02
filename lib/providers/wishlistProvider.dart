import 'dart:convert';

import 'package:chaabra/api/callApi.dart';
import 'package:chaabra/models/WishList.dart';
import 'package:chaabra/models/userModel.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class WishlistProvider extends ChangeNotifier{
    final List<Wishlist> wishlist = [];

    WishlistProvider(){
        fetchWishlistData(context);
    }
    Wishlist wishlistModel = Wishlist();


    CallApi callApi = CallApi();



    addWishlistDb(context,int productId)async{
        showCircularProgressIndicator(context);
        User user = await User().localUserData();
        final data = {
            "customer_id": user.id.toString(),
            "product_id": productId.toString()
        };
        final res = await callApi.postWithConnectionCheck(context,apiUrl: 'wishlist',data: data);
        print(res.body);
        final jsonRes = jsonDecode(res.body);
        if(jsonRes['response'] == "SUCCESS"){
            navPop(context);
            showToast("Product added in wishlist");
            fetchWishlistData(context);
        }
        if(jsonRes['response'] == "ALREADY_EXIST"){
            navPop(context);
            showToast("Product already exist");
        }
    }

    removeWishlistFromDb(context,int productId)async{
        showCircularProgressIndicator(context);
        User user = await User().localUserData();
        final data = {
            "customer_id": user.id.toString(),
            "product_id": productId.toString()
        };
        final res = await callApi.postWithConnectionCheck(context,apiUrl: 'wishlist/remove',data: data);
        print(res.body);
        final jsonRes = jsonDecode(res.body);
        if(jsonRes['response'] == "SUCCESS"){
            navPop(context);
            removeThisProductFromWishlist(productId);
        }
    }

    addThisProductInWishlist(Wishlist product){
        if(wishlistModel.wishlistHasThisProduct(cartItem: product, cartList: wishlist)){
            showToast('${product.product.productDetails.name} is already there in wishlist');
        }else{
            wishlist.add(product);
            showToast('${product.product.productDetails.name} added to wishlist');
            notifyListeners();
        }
    }

    bool isWishlistLoading = false;

    fetchWishlistData(context)async{
        User user = await User().localUserData();
        wishlist.length == 0 ? isWishlistLoading = true : isWishlistLoading = false;
        notifyListeners();
        final res = await callApi.getWithConnectionCheck("wishlist/${user.id}", context);
        final data = jsonDecode(res.body) as List;
        if (data.length != wishlist.length) {
            isWishlistLoading = true;
            wishlist.clear();
            for (Map i in data) {
                wishlist.add(Wishlist.fromJson(i));
            }
            isWishlistLoading = false;
            notifyListeners();
        } else {
            isWishlistLoading = false;
            notifyListeners();
        }
    }


    removeThisProductFromWishlist(int productId){
        wishlist.removeWhere((element) => element.product.id == productId);
        showToast("Removed product from wishlist");
        notifyListeners();
    }
}