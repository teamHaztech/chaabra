import 'package:chaabra/models/productModel.dart';

class Order{
  final int id;
  final OrderStatus status;
  final List<Product> products;

  Order({this.id,this.products,this.status});

  factory Order.fromJson(Map<String, dynamic>json){
    var productList = json['ordered_products'] as List;
    List<Product> products = productList != null ? productList.map((e) => Product.fromJson(e)).toList() : [];
    return Order(
        id: int.parse(json['order']),
        products: products,
        status: OrderStatus.fromJson(json['status'])
    );
  }
}

class OrderStatus{
  final int id;
  final String name;
  OrderStatus({this.id,this.name});
  factory OrderStatus.fromJson(Map<String, dynamic>json){
    return OrderStatus(
        id: int.parse(json['order_status_id']),
        name: json['name']
    );
  }
}