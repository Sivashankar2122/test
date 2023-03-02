import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:ems_mobile/utils/custom_values.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  String empNUmber;
  ChangePassword(this.empNUmber, {super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController newRePassController = TextEditingController();
  String baseUrl = '';

  checkValidte() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
    if (newPassController.text == newRePassController.text) {
      changePassword();
    } else {
      showSnackBar("New Password does not match", AnimatedSnackBarType.error);
    }

    setState(() {});
  }

  changePassword() async {
    try {
      var response = await http.post(Uri.parse('${baseUrl}change-password.php'),body: {
        "emp_number" : widget.empNUmber,
        "password" : currentPassController.text,
        "new_password" : newPassController.text
      });
      var result = await json.decode(response.body);
      print(response.body);
      if (result['success']) {
        showSnackBar(
            result['message'].toString(), AnimatedSnackBarType.success);
            Navigator.of(context).pop();
      } else {
        showSnackBar(result['message'].toString(), AnimatedSnackBarType.error);
      }
    } catch (e) {
      showSnackBar(e.toString(), AnimatedSnackBarType.error);
    }
  }

  showSnackBar(String message, AnimatedSnackBarType type) {
    AnimatedSnackBar.material(
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      message,
      duration: const Duration(seconds: 4),
      type: type,
      // snackBarStrategy:
    ).show(context);
  }

  getbaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = preferences.getString("baseURL").toString();
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Change Password"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Employee Number",
                          style: TextStyle(
                              color: Color.fromRGBO(0, 105, 147, 1),
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        Text(
                          widget.empNUmber,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  passwordField('Current Password', "Enter current password",
                      currentPassController),
                  passwordField(
                      'New Password', "Enter New password", newPassController),
                  passwordField('Re-Type Password', "Enter new password again",
                      newRePassController),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {
                      checkValidte();
                    },
                    child: Container(
                      width: double.infinity,
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
                      child: const Center(
                        child: Text(
                          "Change Password",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget passwordField(
      String label, hintText, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
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
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.text,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.grey),
                hintText: hintText),
            maxLines: 1,
            obscureText: true,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
