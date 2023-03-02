class GetLocation {
  int? id;
  String? empNumber;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;

  GetLocation(
      {this.id,
      this.empNumber,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt});

  GetLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empNumber = json['emp_number'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emp_number'] = this.empNumber;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
