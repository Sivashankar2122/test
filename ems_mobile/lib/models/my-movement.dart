class MyMovements {
  int? id;
  String? empNumber;
  String? date;
  String? type;
  String? latitude;
  String? longitude;
  String? logOn;

  MyMovements(
      {this.id,
      this.empNumber,
      this.date,
      this.type,
      this.latitude,
      this.longitude,
      this.logOn});

  MyMovements.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empNumber = json['emp_number'];
    date = json['date'];
    type = json['type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    logOn = json['log_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emp_number'] = this.empNumber;
    data['date'] = this.date;
    data['type'] = this.type;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['log_on'] = this.logOn;
    return data;
  }
}