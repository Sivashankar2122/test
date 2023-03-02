import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ems_mobile/models/admin/leave_detail.dart';
import 'package:ems_mobile/pages/admin/leave_master.dart';
import 'package:ems_mobile/utils/custom_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LeaveApprove extends StatefulWidget {
  String leaveId;
  LeaveApprove(this.leaveId, {super.key});

  @override
  State<LeaveApprove> createState() => _LeaveApproveState();
}

class _LeaveApproveState extends State<LeaveApprove> {
  LeaveDetails? leaveDetailModel;
  ImageProvider imageProvider = AssetImage('assets/user.png');
   String baseUrl = '';

  getbaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = preferences.getString("baseURL").toString();
    getLeaveDetail();
    setState(() {});
  }

            
  
  leaveStatusUpdate(String status) async {
    try {
      var response = await http.post(Uri.parse('${baseUrl}approve-leave.php'),
          body: {'leave_id': widget.leaveId, 'status': status});
      var result = await json.decode(response.body);

      print(response.body);

      if (result['success']) {
        if (status == '1') {
          showCustomDialogy(
              DialogType.success, "Approved", "Leave Approved Successfully");
        } else if (status == '2') {
          showCustomDialogy(
              DialogType.error, "Declined", "Leave Declined Successfully");
        }
      } else {
        print("error");
        print(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  showCustomDialogy(DialogType type, String title, desc) {
    AwesomeDialog(
      barrierColor: const Color.fromRGBO(0, 105, 147, 1),
      context: context,
      dialogType: type,
      animType: AnimType.bottomSlide,
      title: title,
      desc: desc,
      btnOkOnPress: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LeaveMaster()));
      },
    ).show();
  }

  getLeaveDetail() async {
    try {
      var response = await http.get(Uri.parse(
          '${baseUrl}get-detailed-leave.php?leave_id=${widget.leaveId}'));
      var result = await json.decode(response.body);

      if (result['success']) {
        leaveDetailModel = LeaveDetails.fromJson(result['leave']);
        if (leaveDetailModel!.photoFilePath != null) {
              imageProvider = NetworkImage(
                  "${baseUrl}employee_profile/${leaveDetailModel!.photoFilePath}");
            }
      } else {
        print("error");
        print(response.body);
      }

      if (mounted) {
        // check whether the state object is in tree
        setState(() {
          // make changes here
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getbaseURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Leave Approve"),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: leaveDetailModel != null
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        CircleAvatar(
                          backgroundColor: primaryColor,
                          radius: 60,
                          child: CircleAvatar(
                            radius: 56,
                            backgroundImage: imageProvider,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        customTextField(
                            "Emp Name", "${leaveDetailModel!.empName}"),
                        const SizedBox(
                          height: 10,
                        ),
                        customTextField(
                            "Emp Number", "${leaveDetailModel!.empNumber}"),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: const [
                            Text(
                              "Leave Details",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: [
                              customTextField("Leave Type",
                                  "${leaveDetailModel!.leaveType}"),
                              customTextField("Leave Description",
                                  "${leaveDetailModel!.leaveDescription}"),
                              customTextField("Leave Dates",
                                  "${leaveDetailModel!.fromDate}   To   ${leaveDetailModel!.toDate}"),
                              customTextField("Number of Days",
                                  "${leaveDetailModel!.noOfDays}"),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            customButton(
                                "Approve", "1", Colors.green, Icons.check),
                            customButton(
                                "Decline", "2", Colors.red, Icons.cancel),
                          ],
                        )
                      ],
                    )
                  : const Center(
                      child: SpinKitFadingCircle(
                        color: Colors.black,
                        size: 100.0,
                      ),
                    ))),
    );
  }

  Widget customTextField(String label, value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: Color.fromRGBO(0, 105, 147, 1),
                fontWeight: FontWeight.w600,
                fontSize: 15),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget customButton(
    String label,
    status,
    Color color,
    IconData icon,
  ) {
    return InkWell(
      onTap: () {
        leaveStatusUpdate(status);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
