import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';
import '../utils/custom_values.dart';

class AppAuth extends StatefulWidget {
  const AppAuth({super.key});

  @override
  State<AppAuth> createState() => _AppAuthState();
}

class _AppAuthState extends State<AppAuth> {
  bool hasLocation = false;
  int locationInterval = 0;
  String latitude = '', longitude = '';
  String baseUrl = '';

  getbaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = preferences.getString("baseURL").toString();
    checkUser();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getbaseURL();
  }

  checkUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getString("config").toString() == "true") {
      if (preferences.getString("userState") == "true") {
        String empNumber = preferences.getString("empNumber").toString();
        // print(empNumber);
        addAccessLog(empNumber);
      } else {
        Get.offAllNamed(GetRoutes.login);
      }
    }else{
      Get.offAllNamed(GetRoutes.config);
    }
  }

  addLocation(String empNumber) async {
    try {
      String date =
          "${DateTime.now().year}-${DateTime.now().month}-0${DateTime.now().day}";
      var response =
          await http.post(Uri.parse('${baseUrl}add-location.php'), body: {
        "emp_number": empNumber,
        "date": date,
        "latitude": latitude,
        "longitude": longitude,
      });

      var accessResult = await json.decode(response.body);

      if (accessResult['success']) {
        print("Success");
      } else {
        print("error");
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  addAccessLog(String empNumber) async {
    try {
      var response =
          await http.post(Uri.parse('${baseUrl}add-access-log.php'), body: {
        "emp_number": empNumber,
      });

      var accessResult = await json.decode(response.body);

      if (accessResult['success']) {
        Get.offAllNamed(GetRoutes.home);
      } else {
        print("error");
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
