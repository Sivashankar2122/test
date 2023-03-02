class MyAttendence {
  int? id;
  String? empNumber;
  String? date;
  String? morning;
  String? afternoon;
  String? createdAt;
  String? updatedAt;

  MyAttendence(
      {this.id,
      this.empNumber,
      this.date,
      this.morning,
      this.afternoon,
      this.createdAt,
      this.updatedAt});

  MyAttendence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empNumber = json['emp_number'];
    date = json['date'];
    morning = json['morning'];
    afternoon = json['afternoon'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emp_number'] = this.empNumber;
    data['date'] = this.date;
    data['morning'] = this.morning;
    data['afternoon'] = this.afternoon;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
