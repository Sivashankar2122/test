class CheckInOut {
  String? id;
  String? empNumber;
  String? checkIn;
  String? checkOut;

  CheckInOut({this.id, this.empNumber, this.checkIn, this.checkOut});

  CheckInOut.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empNumber = json['emp_number'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emp_number'] = this.empNumber;
    data['check_in'] = this.checkIn;
    data['check_out'] = this.checkOut;
    return data;
  }
}
