class SearchData{
    final int productId;
    final String name;
    final String image;
    final String price;
    
    SearchData({this.image,this.name,this.productId,this.price});
    
    factory SearchData.fromJson(Map<String, dynamic>json){
        return SearchData(
            productId: json['product_id'],
            name: json['details']['name'],
            image: json['image'],
            price: json['price']
        );
    }
}