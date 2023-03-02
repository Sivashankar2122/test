class Profile {
  int? id;
  String? empNumber;
  String? bioRefNo;
  String? empName;
  String? spouseName;
  String? department;
  String? subDepartment;
  String? designation;
  String? plantName;
  String? dateOfJoining;
  String? salary;
  String? communicationAddress1;
  String? communicationAddress2;
  String? communicationAddress3;
  String? communicationTaluk;
  String? communicationDistrict;
  String? communicationState;
  String? communicationCountry;
  String? communicationPincode;
  String? permanentAddress1;
  String? permanentAddress2;
  String? permanentAddress3;
  String? permanentTaluk;
  String? permanentDistrict;
  String? permanentState;
  String? permanentCountry;
  String? permanentPincode;
  String? mobileAppAccess;
  String? reportsToWhom;
  String? personalEmail;
  String? officialEmail;
  String? mobileNo1;
  String? mobileNo2;
  String? photoFilePath;
  String? locationAccess;
  String? locationInterval;

  Profile(
      {this.id,
      this.empNumber,
      this.bioRefNo,
      this.empName,
      this.spouseName,
      this.department,
      this.subDepartment,
      this.designation,
      this.plantName,
      this.dateOfJoining,
      this.salary,
      this.communicationAddress1,
      this.communicationAddress2,
      this.communicationAddress3,
      this.communicationTaluk,
      this.communicationDistrict,
      this.communicationState,
      this.communicationCountry,
      this.communicationPincode,
      this.permanentAddress1,
      this.permanentAddress2,
      this.permanentAddress3,
      this.permanentTaluk,
      this.permanentDistrict,
      this.permanentState,
      this.permanentCountry,
      this.permanentPincode,
      this.mobileAppAccess,
      this.reportsToWhom,
      this.personalEmail,
      this.officialEmail,
      this.mobileNo1,
      this.mobileNo2,
      this.photoFilePath,
      this.locationAccess,
      this.locationInterval});

  Profile.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    empNumber = json['emp_number'];
    bioRefNo = json['bio_ref_no'];
    empName = json['emp_name'];
    spouseName = json['spouse_name'];
    department = json['department'];
    subDepartment = json['sub_department'];
    designation = json['designation'];
    plantName = json['plant_name'];
    dateOfJoining = json['date_of_joining'];
    salary = json['salary'];
    communicationAddress1 = json['communication_address1'];
    communicationAddress2 = json['communication_address2'];
    communicationAddress3 = json['communication_address3'];
    communicationTaluk = json['communication_taluk'];
    communicationDistrict = json['communication_district'];
    communicationState = json['communication_state'];
    communicationCountry = json['communication_country'];
    communicationPincode = json['communication_pincode'];
    permanentAddress1 = json['permanent_address1'];
    permanentAddress2 = json['permanent_address2'];
    permanentAddress3 = json['permanent_address3'];
    permanentTaluk = json['permanent_taluk'];
    permanentDistrict = json['permanent_district'];
    permanentState = json['permanent_state'];
    permanentCountry = json['permanent_country'];
    permanentPincode = json['permanent_pincode'];
    mobileAppAccess = json['mobile_app_access'];
    reportsToWhom = json['reports_to_whom'];
    personalEmail = json['personal_email'];
    officialEmail = json['official_email'];
    mobileNo1 = json['mobile_no1'];
    mobileNo2 = json['mobile_no2'];
    photoFilePath = json['photo_file_path'];
    locationAccess = json['location_access'];
    locationInterval = json['location_interval'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emp_number'] = this.empNumber;
    data['bio_ref_no'] = this.bioRefNo;
    data['emp_name'] = this.empName;
    data['spouse_name'] = this.spouseName;
    data['department'] = this.department;
    data['sub_department'] = this.subDepartment;
    data['designation'] = this.designation;
    data['plant_name'] = this.plantName;
    data['date_of_joining'] = this.dateOfJoining;
    data['salary'] = this.salary;
    data['communication_address1'] = this.communicationAddress1;
    data['communication_address2'] = this.communicationAddress2;
    data['communication_address3'] = this.communicationAddress3;
    data['communication_taluk'] = this.communicationTaluk;
    data['communication_district'] = this.communicationDistrict;
    data['communication_state'] = this.communicationState;
    data['communication_country'] = this.communicationCountry;
    data['communication_pincode'] = this.communicationPincode;
    data['permanent_address1'] = this.permanentAddress1;
    data['permanent_address2'] = this.permanentAddress2;
    data['permanent_address3'] = this.permanentAddress3;
    data['permanent_taluk'] = this.permanentTaluk;
    data['permanent_district'] = this.permanentDistrict;
    data['permanent_state'] = this.permanentState;
    data['permanent_country'] = this.permanentCountry;
    data['permanent_pincode'] = this.permanentPincode;
    data['mobile_app_access'] = this.mobileAppAccess;
    data['reports_to_whom'] = this.reportsToWhom;
    data['personal_email'] = this.personalEmail;
    data['official_email'] = this.officialEmail;
    data['mobile_no1'] = this.mobileNo1;
    data['mobile_no2'] = this.mobileNo2;
    data['photo_file_path'] = this.photoFilePath;
    data['location_access'] = this.locationAccess;
    data['location_interval'] = this.locationInterval;
    return data;
  }
}