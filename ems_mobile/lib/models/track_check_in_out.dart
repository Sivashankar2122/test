class TrackCheckInOut {
  String? id;
  String? empNumber;
  String? checkIn;
  String? checkOut;
  String? checkinLatitude;
  String? checkinLongitude;
  String? checkoutLatitude;
  String? checkoutLongitude;
  String? checkinAddress;
  String? checkoutAddress;
  String? checkInImage;
  String? checkOutImage;
  String? createdAt;
  String? updatedAt;

  TrackCheckInOut(
      {this.id,
      this.empNumber,
      this.checkIn,
      this.checkOut,
      this.checkinLatitude,
      this.checkinLongitude,
      this.checkoutLatitude,
      this.checkoutLongitude,
      this.checkinAddress,
      this.checkoutAddress,
      this.checkInImage,
      this.checkOutImage,
      this.createdAt,
      this.updatedAt});

  TrackCheckInOut.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    empNumber = json['emp_number'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    checkinLatitude = json['checkin_latitude'].toString();
    checkinLongitude = json['checkin_longitude'].toString();
    checkoutLatitude = json['checkout_latitude'].toString();
    checkoutLongitude = json['checkout_longitude'].toString();
    checkinAddress = json['checkin_address'];
    checkoutAddress = json['checkout_address'];
    checkInImage = json['check_in_image'];
    checkOutImage = json['check_out_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emp_number'] = this.empNumber;
    data['check_in'] = this.checkIn;
    data['check_out'] = this.checkOut;
    data['checkin_latitude'] = this.checkinLatitude;
    data['checkin_longitude'] = this.checkinLongitude;
    data['checkout_latitude'] = this.checkoutLatitude;
    data['checkout_longitude'] = this.checkoutLongitude;
    data['checkin_address'] = this.checkinAddress;
    data['checkout_address'] = this.checkoutAddress;
    data['check_in_image'] = this.checkInImage;
    data['check_out_image'] = this.checkOutImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
