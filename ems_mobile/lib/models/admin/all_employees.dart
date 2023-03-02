class AllEmployee {
  int? id;
  String? empNumber;
  String? empName;
  String? department;
  String? photoFilePath;

  AllEmployee(
      {this.id,
      this.empNumber,
      this.empName,
      this.department,
      this.photoFilePath});

  AllEmployee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empNumber = json['emp_number'];
    empName = json['emp_name'];
    department = json['department'];
    photoFilePath = json['photo_file_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emp_number'] = this.empNumber;
    data['emp_name'] = this.empName;
    data['department'] = this.department;
    data['photo_file_path'] = this.photoFilePath;
    return data;
  }
}