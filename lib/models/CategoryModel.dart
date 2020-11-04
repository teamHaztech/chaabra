import 'package:chaabra/models/productModel.dart';

class CategoryModel{
  final String name;
  final String image;
  final int id;

  CategoryModel({this.image,this.name,this.id});

  factory CategoryModel.fromJson(Map<String, dynamic> json){
    return CategoryModel(
      id: json['category_id'],
      name: json['description']['name'],
      image: json['image']
    );
  }
}


class CategoryProduct {
  final Product product;
  CategoryProduct({this.product});

  factory CategoryProduct.fromJson(Map<String, dynamic> json){
    return CategoryProduct(
        product : Product.fromJson(json['product'])
    );
  }
}