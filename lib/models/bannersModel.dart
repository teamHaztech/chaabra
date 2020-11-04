
class BannerModel{
    final int id;
    final String image;
    bool active;
    BannerModel({this.image,this.active = false,this.id});
    
    factory BannerModel.fromJson(Map<String, dynamic> json){
        return BannerModel(
            id: json['banner_image_id'],
            image: json['image']
        );
    }
}