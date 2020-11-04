class DeliveryAddress {
  final int id;
  final String firstname;
  final String lastname;
  final String company;
  final String address_1;
  final String address_2;
  final String city;
  final String postcode;
  final int country_id;
  final int zone_id;

  bool selectState;

  DeliveryAddress(
      {this.id,
      this.address_1,
      this.address_2,
      this.city,
      this.company,
      this.country_id,
      this.firstname,
      this.lastname,
      this.postcode,
      this.zone_id});


  factory DeliveryAddress.fromJson(Map<String, dynamic> json){
      return DeliveryAddress(
          id: json[''],
          firstname: json[''],
          lastname: json[''],
          company: json[''],
          address_1: json[''],
          address_2: json[''],
          city: json[''],
          postcode: json[''],
          country_id: int.parse(json['']),
          zone_id: int.parse(json['']),
      );
  }
}
