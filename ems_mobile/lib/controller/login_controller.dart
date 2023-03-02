import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/routes.dart';
import '../utils/custom_values.dart';
import '../utils/shared_pref.dart';

class LoginController extends GetxController {
  late TextEditingController userNameController, passwordController;




  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    userNameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    userNameController.dispose();
    passwordController.dispose();
  }

  checkLogin(String url) {
    if (userNameController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Empty UserName",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 15,
        );
    } else if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Empty Password",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 15,
        );
    } else {
      Get.showOverlay(
          asyncFunction: () => login(url),
          loadingWidget: const Padding(
            padding: EdgeInsets.only(top: 200),
            child: SpinKitFadingCircle(
              color: Colors.black,
              size: 100.0,
            ),
          ));
    }
  }

  login(String url) async {
    try {
      var response = await http.post(Uri.parse('${url}login.php'), body: {
        "emp_number": userNameController.text,
        "password": passwordController.text,
      });

      var loginResult = await json.decode(response.body);
      print(response.body);

      if (loginResult['success']) {
        var userNameResponse = await http.post(Uri.parse(
            '${url}get-empname.php?emp_number=${loginResult['userDetails']['emp_number'].toString()}'));
        var userNameResult = await json.decode(userNameResponse.body);

        if (userNameResult['success']) {
          await SharedPrefs().storeUser(
            loginResult['userDetails']['emp_number'].toString(),
            loginResult['userDetails']['role_id'].toString(),
            userNameResult['emp_name'].toString(),
          );
          Get.offNamed(GetRoutes.permission);
        } else {
          print("error");
          print(userNameResponse.body);
        }
      } else {
        Fluttertoast.showToast(
          msg: "Invalid Login",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 15,
        );
        print("error");
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }
}
