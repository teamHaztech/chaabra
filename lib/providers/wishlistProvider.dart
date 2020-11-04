import 'package:chaabra/models/WishList.dart';
import 'package:chaabra/screens/constants.dart';
import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier{
    final List<Wishlist> wishlist = [];
    
    Wishlist wishlistModel = Wishlist();
    
    addThisProductInWishlist(Wishlist product){
        if(wishlistModel.wishlistHasThisProduct(cartItem: product, cartList: wishlist)){
            showToast('${product.product.productDetails} is already there in wishlist');
        }else{
            wishlist.add(product);
            showToast('${product.product.productDetails} added to wishlist');
            notifyListeners();
        }
    }

    removeThisProductFromWishlist(Wishlist cartItem){
        wishlist.removeWhere((element) => element.product.id == cartItem.product.id);
        showToast('${cartItem.product.productDetails} is removed from wishlist');
        notifyListeners();
    }
}