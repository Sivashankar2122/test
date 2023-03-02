class LeaveDetails {
  int? id;
  String? empName;
  String? empNumber;
  String? leaveType;
  String? leaveDescription;
  String? fromDate;
  String? toDate;
  int? noOfDays;
  String? photoFilePath;

  LeaveDetails(
      {this.id,
      this.empName,
      this.empNumber,
      this.leaveType,
      this.leaveDescription,
      this.fromDate,
      this.toDate,
      this.noOfDays,
      this.photoFilePath});

  LeaveDetails.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    empName = json['emp_name'];
    empNumber = json['emp_number'];
    leaveType = json['leave_type'];
    leaveDescription = json['leave_description'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    noOfDays = int.parse(json['no_of_days'].toString());
    photoFilePath = json['photo_file_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emp_name'] = this.empName;
    data['emp_number'] = this.empNumber;
    data['leave_type'] = this.leaveType;
    data['leave_description'] = this.leaveDescription;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['no_of_days'] = this.noOfDays;
    data['photo_file_path'] = this.photoFilePath;
    return data;
  }
}