import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ems_mobile/pages/view_leave.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:http/http.dart' as http;
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/custom_values.dart';

class ApplyLeave extends StatefulWidget {
  String empName, empNumber;
  ApplyLeave(this.empName, this.empNumber, {super.key});

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  String selectedLeave = '', leaveDes = '', leaveDays = '';
  DateTime fromDate = DateTime.now(), toDate = DateTime.now();
  TextEditingController leaveTypeController = TextEditingController();
  TextEditingController noOfLeaveController = TextEditingController();
  double screenHeight = 0;
  List<String> leaveType = [''];
  bool isLeaveDes = false;
  late int leaveId;
  String baseUrl = '';

  getbaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = preferences.getString("baseURL").toString();
    fetchTypes();
    setState(() {});
  }

  Future<void> fetchTypes() async {
    try {
      var response = await http.get(Uri.parse('${baseUrl}get-leave-type.php'));
      var result = await json.decode(response.body);
      if (result['success']) {
        leaveType.clear();
        for (var item in result['leaves']) {
          leaveType.add(item.toString());
        }
      } else {
        if (kDebugMode) {
          print(response.body);
          print(response.body);
        }
      }
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  fetchLeaveDetails() async {
    try {
      var response = await http.get(Uri.parse(
          '${baseUrl}get-leave-detail.php?leave_type=$selectedLeave&emp_number=${widget.empNumber}'));
      var result = await json.decode(response.body);
      if (result['success']) {
        leaveDes = result['leave_details']['leave_description'];
        leaveDays = result['leave_details']['no_of_days'];
        leaveId = int.parse(result['leave_details']['id']);
        isLeaveDes = true;
      } else {
        if (kDebugMode) {
          print("error");
          print(response.body);
        }
      }
      if (mounted) {
        // check whether the state object is in tree
        setState(() {
          // make changes here
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  addLeave() async {
    try {
      var response =
          await http.post(Uri.parse('${baseUrl}add-leave.php'), body: {
        "emp_number": widget.empNumber,
        "leave_id": leaveId.toString(),
        "from_date":fromDate.toString().substring(0,10),
        "to_date":toDate.toString().substring(0,10),
        "no_of_days":noOfLeaveController.text
      });

      var addLeaveResult = await json.decode(response.body);
      if (addLeaveResult['success']) {
        AwesomeDialog(
          barrierColor:const Color.fromRGBO(0, 105, 147, 1) ,
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'Success',
            desc: 'Successfully Leave Applied',
            btnOkOnPress: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ViewLeave(widget.empName, widget.empNumber)));
            },
            ).show();
      } else {
        if (kDebugMode) {
          print("error");
          print(response.body);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
     getbaseURL();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 214, 225, 231),
      appBar: AppBar(
        title: const Text(
          'Request Leave',
          style: TextStyle(
            fontFamily: 'Signika',
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        elevation: 0.0,
        backgroundColor: const Color.fromRGBO(0, 105, 147, 1),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Column(
                children: [
                  const Text(
                    "Apply a Leave",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: const [
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Employee Details",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Emp Number",
                          style: TextStyle(
                              color: Color.fromRGBO(0, 105, 147, 1),
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        Text(
                          widget.empNumber,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Name",
                          style: TextStyle(
                              color: Color.fromRGBO(0, 105, 147, 1),
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        Text(
                          widget.empName,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: const [
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Leave Details",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomDropdown(
                    borderRadius: BorderRadius.circular(8),
                    hintText: 'Select Leave Type',
                    items: leaveType,
                    controller: leaveTypeController,
                    excludeSelected: true,
                    onChanged: (item) {
                      setState(() {
                        selectedLeave = item;
                        fetchLeaveDetails();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  isLeaveDes
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Description",
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 105, 147, 1),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                              ),
                              Text(
                                leaveDes,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Total days Leave",
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 105, 147, 1),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                              ),
                              Text(
                                leaveDays,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(height: 0),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2500),
                          ).then((value) {
                            setState(() {
                              fromDate = value!;
                            });
                          });
                        },
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                        ),
                        label: Text(
                          "${fromDate.day.toString()}-${fromDate.month.toString()}-${fromDate.year.toString()}",
                          style: const TextStyle(
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                            color: Colors.grey,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2500),
                          ).then((value) {
                            setState(() {
                              toDate = value!;
                            });
                          });
                        },
                        icon: const Icon(Icons.calendar_today,
                            color: Colors.grey),
                        label: Text(
                          "${toDate.day.toString()}-${toDate.month.toString()}-${toDate.year.toString()}",
                          style: const TextStyle(
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                            color: Colors.grey,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: TextFormField(
                      controller: noOfLeaveController,
                      keyboardType: TextInputType.number,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "No of Days"),
                      maxLines: 1,
                      obscureText: false,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {
                      addLeave();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 105, 147, 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(2, 2),
                          )
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: const Text(
                        "Request Leave",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
