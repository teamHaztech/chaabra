import 'package:chaabra/models/productModel.dart';

class Cart {
    final Product product;
    Cart({this.product});
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


