class AllLeaves {
  int? id;
  String? empName;
  String? empNumber;
  String? fromDate;
  String? toDate;
  int? noOfDays;

  AllLeaves(
      {this.id,
      this.empName,
      this.empNumber,
      this.fromDate,
      this.toDate,
      this.noOfDays});

  AllLeaves.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empName = json['emp_name'];
    empNumber = json['emp_number'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    noOfDays = json['no_of_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emp_name'] = this.empName;
    data['emp_number'] = this.empNumber;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['no_of_days'] = this.noOfDays;
    return data;
  }
}
