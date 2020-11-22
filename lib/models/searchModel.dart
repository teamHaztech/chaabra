import 'package:chaabra/models/productModel.dart';

class SearchData{
    final Product product;
    
    SearchData({this.product});
    
    factory SearchData.fromJson(Map<String, dynamic>json){
        return SearchData(
            product: Product.fromJson(json)
        );
    }
}