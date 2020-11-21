import 'package:chaabra/models/productModel.dart';

class Order{
  final int id;
  final OrderStatus status;
  final List<OrderedProduct> orderedProducts;

  Order({this.id,this.orderedProducts,this.status});

  factory Order.fromJson(Map<String, dynamic>json){
    var productList = json['ordered_products'] as List;
    List<OrderedProduct> products = productList != null ? productList.map((e) => OrderedProduct.fromJson(e)).toList() : [];
    return Order(
        id: json['order_id'],
        orderedProducts: products,
        status: OrderStatus.fromJson(json['status'])
    );
  }
}



class OrderedProduct{
  final double totalPrice;
  final Product product;
  OrderedProduct({this.product,this.totalPrice});
  factory OrderedProduct.fromJson(Map<String, dynamic>json){
    return OrderedProduct(
      totalPrice: double.parse(json['total']),
      product: Product.fromJson(json['product'])
    );
  }
}


class OrderStatus{
  final int id;
  final String name;
  OrderStatus({this.id,this.name});
  factory OrderStatus.fromJson(Map<String, dynamic>json){
    return OrderStatus(
        id: json['order_status_id'],
        name: json['name']
    );
  }
}