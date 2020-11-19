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

