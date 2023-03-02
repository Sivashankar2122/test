import 'dart:convert';
import 'package:ems_mobile/models/admin/all_employees.dart';
import 'package:ems_mobile/pages/admin/employee_details.dart';
import 'package:ems_mobile/utils/custom_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  List<AllEmployee>? employeeModel;
  bool hasError = false;
  String errorMsg = '';
   String baseUrl = '';

  getbaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = preferences.getString("baseURL").toString();
    fetchEmployee();
    setState(() {});
  }

  fetchEmployee() async {
    try {
      var response = await http.post(Uri.parse('${baseUrl}employee-list.php'));
      var result = await json.decode(response.body);
      print(response.body);
      if (result['success']) {
        employeeModel = result['employee']
            .map((item) => AllEmployee.fromJson(item))
            .toList()
            .cast<AllEmployee>();
        hasError = false;
      } else {
        hasError = true;
        errorMsg = result['message'];
      }
    } catch (e) {
      hasError = true;
      errorMsg = e.toString();
    }
    setState(() {});
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
        appBar: AppBar(
          title: const Text(
            'Employee List',
            style: TextStyle(
              fontFamily: 'signika',
              letterSpacing: 2.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: false,
          backgroundColor: const Color.fromRGBO(0, 105, 147, 1),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
          child: Column(
            mainAxisAlignment: employeeModel == null
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              employeeModel == null
                  ? hasError
                      ? Center(
                          child: Text(
                          errorMsg,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ))
                      : const Center(
                          child: SpinKitFadingCircle(
                            color: Colors.black,
                            size: 100.0,
                          ),
                        )
                  : getEmployee()
            ],
          ),
        ));
  }

  Widget getEmployee() {
    return Expanded(
      child: ListView.builder(
          itemCount: employeeModel!.length,
          itemBuilder: (BuildContext context, int index) {
            ImageProvider imageProvider = AssetImage('assets/user.png');

            if (employeeModel![index].photoFilePath != null) {
              imageProvider = NetworkImage(
                  "${baseUrl}employee_profile/${employeeModel![index].photoFilePath}");
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmpDetail(
                                employeeModel![index].id.toString(),
                                employeeModel![index].empNumber.toString(),
                                employeeModel![index].empName.toString(),
                                employeeModel![index].department.toString(),
                                employeeModel![index].photoFilePath.toString(),
                              )));
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: imageProvider,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${employeeModel![index].empName}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          Text(
                            "${employeeModel![index].empNumber}",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
