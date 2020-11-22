class SearchData{
    final int productId;
    final String name;
    final String image;
    
    SearchData({this.image,this.name,this.productId});
    
    factory SearchData.fromJson(Map<String, dynamic>json){
        return SearchData(
            productId: int.parse(json['product_id']),
            name: json['details']['name'],
            image: json['image'],
        );
    }
}