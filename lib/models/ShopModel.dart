class Shop {
    final int id;
    final String name;
    final String image;
    
    Shop({this.id,this.image,this.name});
    
    factory Shop.fromJson(Map<String, dynamic> json){
        return Shop(
            id: json['manufacturer_id'],
            name: json['name'],
            image: json['image']
        );
    }
}