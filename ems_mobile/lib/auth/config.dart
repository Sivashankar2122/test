import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:ems_mobile/utils/custom_values.dart';
import 'package:ems_mobile/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  TextEditingController urlController = TextEditingController();
  String selectedConnection = '';

  addConfig() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("baseURL", urlController.text.toString());
    preferences.setString("config", "true");
    print(SharedPrefs().getbaseURL().toString());
    Navigator.pushNamed(context, 'auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 222, 222),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Config Your App Settings"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25,),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding:
                    const EdgeInsets.fromLTRB(15, 10, 15, 0),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "URL",
                      style: TextStyle(
                          color: Color.fromRGBO(0, 105, 147, 1),
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    TextFormField(
                      controller: urlController,
                      keyboardType: TextInputType.text,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "Enter full URL"),
                      maxLines: 1,
                      obscureText: false,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25,),
              InkWell(
                    onTap: () {
                      addConfig();
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
                          "Config URL",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
