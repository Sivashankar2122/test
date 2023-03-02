import 'dart:convert';

import 'package:ems_mobile/utils/custom_values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  storeUser(userName, userRole, empName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("userState", "true");
    preferences.setString("empNumber", userName);
    preferences.setString("userRole", userRole);
    preferences.setString("empName", empName);
  }

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("user");
  }

  removeUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("userState");
    preferences.remove("empNumber");
    preferences.remove("userRole");
    preferences.remove("empName");
  }

  getbaseURL()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String url = preferences.getString("baseURL").toString(); 
    return url;
  }
}
