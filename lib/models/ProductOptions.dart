import 'package:chaabra/models/productModel.dart';

class ProductOption{
  final Product product;
  final List<Option> option;
  ProductOption({this.option,this.product});
  factory ProductOption.fromJson(Map<String, dynamic>json){

    var optionList = json['options'] as List;
    List<Option> option = optionList != null ? optionList.map((e) => Option.fromJson(e)).toList() : [];

    return ProductOption(
        product: Product.fromJson(json['product']),
        option: option,
    );
  }
}


class Option{
  final int optionId;
  final List<OptionValue> optionValue;
  Option({this.optionValue,this.optionId});
  factory Option.fromJson(Map<String, dynamic>json){
    var optionValuesList = json['option_values'] as List;
    List<OptionValue> optionValue = optionValuesList != null ? optionValuesList.map((e) => OptionValue.fromJson(e)).toList() : [];
    return Option(
      optionValue: optionValue
    );
  }
}

class OptionValue{
  final String name;
  OptionValue({this.name});

  factory OptionValue.fromJson(Map<String, dynamic> json){
    return OptionValue(
      name: json['option_value_description']['name']
    );
  }
}