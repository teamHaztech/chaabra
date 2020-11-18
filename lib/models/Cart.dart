import 'dart:collection';

import 'package:chaabra/models/productModel.dart';

import 'ProductOptions.dart';

class Cart {
    final int id;
    bool isRemoving;
    final Product  product;
    final List<CartOption> selectedOption;
    final double kg;
    Cart({this.id,this.product,this.selectedOption,this.kg, this.isRemoving = false});

    factory Cart.fromJson(Map<String, dynamic> json){
        var optionList = json['option'] as List;
        List<CartOption> options = optionList != null ? optionList.map((e) => CartOption.fromJson(e)).toList() : [];
        return Cart(
            id: json['cart_id'],
            product: Product.fromJson(json["product"]),
            selectedOption: options,
        );
    }

    cartHasThisProduct({Cart cartItem, List<Cart> cartList}) {
        bool isThere = false;
        for (var i in cartList) {
            if (i.product.id == cartItem.product.id) {
                isThere = true;
            }
        }
        return isThere;
    }

}

class CartOption{
    final String weight;
    final double price;
    CartOption({this.weight,this.price
    });
    factory CartOption.fromJson(Map<String, dynamic>json){
        return CartOption(
            weight: json['option_value_description']['name'],
            price: double.parse(json['price'])
        );
    }
}

