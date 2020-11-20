class DeliveryAddress {
  final int id;
  final String firstName;
  final String lastName;
  final String company;
  final String address1;
  final String address2;
  final String city;
  final String postcode;
  final int countryCode;
  final int zoneId;

  bool selectState;

  DeliveryAddress(
      {
      this.id,
      this.address1,
      this.address2,
      this.city,
      this.company,
      this.countryCode = 17,
      this.firstName,
      this.lastName,
      this.postcode,
      this.zoneId,
      });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json){
      return DeliveryAddress(
          id: json['address_id'],
          firstName: json['firstname'],
          lastName: json['lastname'],
          company: json['company'],
          address1: json['address_1'],
          address2: json['address_2'],
          city: json['city'],
          postcode: json['postcode'],
          zoneId: int.parse(json['zone_id']),
      );
  }
}

class Zone{
  final int zoneId;
  final int countryId;
  final String name;
  final String code;
  Zone({this.name,this.code,this.countryId,this.zoneId});

  factory Zone.fromJson(Map<String, dynamic> json){
    return Zone(
      zoneId: int.parse(json['zone_id']),
      countryId: int.parse(json['country_id']),
      code: json['code'],
      name: json['name'],
    );
  }


  Map<String, dynamic> toJson(Zone zone){
    return {
      "zone_id": zone.zoneId.toString(),
      "country_id" : "17",
      "zone_name" : zone.name,
      "zone_code": zone.code
    };
  }
}
