import 'package:chaabra/models/productModel.dart';

class Order{
  final int id;
  final OrderStatus status;
  final List<OrderedProduct> orderedProducts;
  final OrderCharges orderCharges;
  final DateTime dateAdded;
  final Payment paymentDetails;

  Order({this.id,this.orderedProducts,this.status,this.orderCharges,this.dateAdded,this.paymentDetails});

  factory Order.fromJson(Map<String, dynamic>json){
    var productList = json['ordered_products'] as List;
    List<OrderedProduct> products = productList != null ? productList.map((e) => OrderedProduct.fromJson(e)).toList() : [];
    return Order(
        id: json['order_id'],
        orderedProducts: products,
        status: OrderStatus.fromJson(json['status']),
        orderCharges: OrderCharges.fromJson(json['order_charges']),
        dateAdded: DateTime.parse(json['date_added']),
        paymentDetails: Payment.fromJson(json),
    );
  }
}

class OrderedProduct{
  final double totalPrice;
  final Product product;
  final String option;
  OrderedProduct({this.product,this.totalPrice,this.option});
  factory OrderedProduct.fromJson(Map<String, dynamic>json){
    return OrderedProduct(
      totalPrice: double.parse(json['total']),
      product: Product.fromJson(json['product']),
      option: json['product_option'][0]['value']
    );
  }
}


class OrderCharges{
  final double total;
  final double shipping;
  final double subTotal;
  OrderCharges({this.shipping,this.subTotal,this.total});

  factory OrderCharges.fromJson(Map<String, dynamic>json){
    return OrderCharges(
      total: double.parse(json['total']),
      shipping: double.parse(json['shipping']),
      subTotal: double.parse(json['sub_total'])
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

class Payment{
  final String method;
  final String name;
  final String country;
  final String zone;
  final String address;
  Payment({this.name,this.country,this.method,this.zone,this.address});

  factory Payment.fromJson(Map<String, dynamic>json){
    return Payment(
      method: json['payment_method'],
      name: "${json['payment_firstname']} ${json['payment_lastname']}",
      country: json['payment_country'],
      zone: json['payment_zone'],
      address: json['payment_address_1']
    );
  }
}