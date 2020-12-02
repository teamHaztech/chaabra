import 'package:chaabra/models/productModel.dart';

class Wishlist{
    final Product product;
    Wishlist({this.product});

    factory Wishlist.fromJson(Map<String, dynamic>json){
        return Wishlist(
            product: Product.fromJson(json['product'])
        );
    }


    wishlistHasThisProduct({Wishlist cartItem, List<Wishlist> cartList}){
        bool isThere = false;
        for(var i in cartList){
            if(i.product.id == cartItem.product.id){
                isThere = true;
            }
        }
        return isThere;
    }
}