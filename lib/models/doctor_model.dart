class DoctorModel {
  String? id;
  String? name;
  String? phoneNo;
  String? addressLongitude;
  String? addressLatitude;
  String? address;
  String? speciality;
  String? bio;
  String? image;
  String? lastMessage;

  DoctorModel(
    this.id,
    this.name,
    this.phoneNo,
    this.address,
    this.addressLatitude,
    this.addressLongitude,
    this.speciality,
    this.bio,
    this.image,
  );

  DoctorModel.fromJson(Map<String, dynamic>? json, {this.lastMessage}) {
    id = json!['id'];
    name = json['name'];
    phoneNo = json['phoneNo'];
    address = json['address']['text'];
    addressLongitude = json['address']['addressLongitude'];
    addressLatitude = json['address']['addressLatitude'];
    speciality = json['speciality'];
    bio = json['bio'];
    image = json['image'];
  }
  DoctorModel.fromCache(Map<String, dynamic>? json, {this.lastMessage}) {
    id = json!['id'];
    name = json['name'];
    phoneNo = json['phoneNo'];
    address = json['text'];
    addressLongitude = json['addressLongitude'];
    addressLatitude = json['addressLatitude'];
    speciality = json['speciality'];
    bio = json['bio'];
    image = json['image'];
  }
}
