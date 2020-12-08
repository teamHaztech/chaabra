import 'package:chaabra/providers/LanguageHandler.dart';
import 'package:provider/provider.dart';

import 'ProductOptions.dart';

class Product {
    final int id;
    final String image;
    final String type;
    final List<ProductDetails> productDetails;
    final double price;
    final String model;
    final int rating;
    final List<Option> options;
    Product({this.id,this.rating,this.image, this.price, this.productDetails, this.model,this.type,this.options});



    factory Product.fromJson(Map<String , dynamic>json){
        var optionList = json['options'] as List;
        List<Option> option = optionList != null ? optionList.map((e) => Option.fromJson(e)).toList() : [];

        var productDetailsList = json['details'] as List;
        List<ProductDetails> details = productDetailsList != null ? productDetailsList.map((e) => ProductDetails.fromJson(e)).toList() : [] ;

        return Product(
            id: int.parse(json['product_id'].toString()),
            image: json['image'],
            model: json['model'],
            price: json['price'] == null ? 0.0 : double.parse(json['price']),
            productDetails: details,
            rating: json['review_count'] == null ? null : int.parse(json['review_count']),
            options: option
        );
    }

    Map<String, dynamic> toJson(Product product) => {
        'product_id': product.id,
        'image': product.image,
        "model": product.model,
        "price": product.price.toString(),
        "details": ProductDetails().toJson(product.productDetails[0])
    };

}


class ProductDetails{
    final String name;
    final String description;
    final int languageId;

    ProductDetails({this.name,this.description,this.languageId});

    factory ProductDetails.fromJson(Map<String, dynamic>json){
        return ProductDetails(
            name: json['name'],
            languageId: json['language_id'] == null ? null : int.parse(json['language_id']) ,
            description: json['description']
        );
    }

    Map<String, dynamic> toJson(ProductDetails productDetails) => {
        'name': productDetails.name,
        'description': productDetails.description,
    };
}


class BestSeller{
    final Product product;
    BestSeller({this.product});
    factory BestSeller.fromJson(Map<String,dynamic>json){
        return BestSeller(
            product: Product.fromJson(json['product'])
        );
    }
}

class MostViewed{
    final Product product;
    MostViewed({this.product});
    factory MostViewed.fromJson(Map<String,dynamic>json){
        return MostViewed(
            product: Product.fromJson(json)
        );
    }
}
