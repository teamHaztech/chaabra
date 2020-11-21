import 'dart:collection';

import 'package:chaabra/models/productModel.dart';
import 'package:chaabra/providers/cartProvider.dart';
import 'package:provider/provider.dart';

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

    Map<String, dynamic> toJson(context, Cart cart) => {
        'cart_id': cart.id,
        "price" : Provider.of<CartProvider>(context,listen: false).getProductTotalInCart(cart.product.id),
        'product': Product().toJson(cart.product),
        'option': CartOption().toJsonArray(cart.selectedOption),
    };

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
    final int optionId;
    final int productOptionId;
    final int productOptionValueId;
    final String weight;
    final double price;

    CartOption({this.weight,this.price,this.productOptionId,this.productOptionValueId,this.optionId});

    factory CartOption.fromJson(Map<String, dynamic>json){
        return CartOption(
            optionId: int.parse(json['option_id']),
            productOptionId: int.parse(json['product_option_id']),
            productOptionValueId: json['product_option_value_id'],
            weight: json['option_value_description']['name'],
            price: double.parse(json['price']),
        );
    }

    // ignore: missing_return
    List<Map<String, dynamic>> toJsonArray(List<CartOption> selectedOption){
        List<Map<String, dynamic>> optionList = [];
        selectedOption.forEach((element) {
            Map<String, dynamic> option;
            option = toJson(element);
            optionList.add(option);
        });
        return optionList;
    }
    
    Map<String, dynamic> toJson(CartOption cartOption) => {
        'option_id': cartOption.optionId,
        'productOptionId': cartOption.productOptionId,
        'productOptionValue': cartOption.productOptionValueId,
        'weight': cartOption.weight,
        'price': cartOption.price
    };
}

