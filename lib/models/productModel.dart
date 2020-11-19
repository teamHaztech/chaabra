class Product {
    final int id;
    final String image;
    final String type;
    final ProductDetails productDetails;
    final double price;
    final String model;
    Product({this.id, this.image, this.price, this.productDetails, this.model,this.type});
    
    factory Product.fromJson(Map<String , dynamic>json){
        return Product(
            id: json['product_id'],
            image: json['image'],
            model: json['model'],
            price: double.parse(json['price']),
            productDetails: ProductDetails.fromJson(json['details'])
        );
    }

    Map<String, dynamic> toJson(Product product) => {
        'product_id': product.id,
        'image': product.image,
        "model": product.model,
        "price": product.price.toString(),
        "details": ProductDetails().toJson(product.productDetails)
    };

}


class ProductDetails{
    final String name;
    final String description;
    ProductDetails({this.name,this.description});

    factory ProductDetails.fromJson(Map<String, dynamic>json){
        return ProductDetails(
          name: json['name'],
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

