import 'dart:collection';

import 'package:chaabra/models/productModel.dart';

class Cart {
    final Product product;
    final LinkedHashMap selectedOption;
    Cart({this.product,this.selectedOption});
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


