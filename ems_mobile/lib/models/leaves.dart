class Leaves {
  String? fromDate;
  String? toDate;
  int? noOfDays;
  String? leaveType;
  String? leaveDescription;
  String? status;

  Leaves(
      {this.fromDate,
      this.toDate,
      this.noOfDays,
      this.leaveType,
      this.leaveDescription,
      this.status});

  Leaves.fromJson(Map<String, dynamic> json) {
    fromDate = json['from_date'];
    toDate = json['to_date'];
    noOfDays = json['no_of_days'];
    leaveType = json['leave_type'];
    leaveDescription = json['leave_description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['no_of_days'] = this.noOfDays;
    data['leave_type'] = this.leaveType;
    data['leave_description'] = this.leaveDescription;
    data['status']=this.status;
    return data;
  }
}
