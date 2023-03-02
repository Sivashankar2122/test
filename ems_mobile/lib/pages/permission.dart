import 'package:app_settings/app_settings.dart';
import 'package:ems_mobile/routes/routes.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:ems_mobile/pages/Dashboard.dart';
import 'package:flutter/material.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  late PermissionStatus _permissionStatus;
  bool isCamera = false, isLocation = false, isAllSettings = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 236, 240),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "Ask Permission",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'signika',
                        letterSpacing: 2.0),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Allow requested permission to",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 155, 154, 154),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'signika',
                        letterSpacing: 1.0),
                  ),
                  Text(
                    "start the app",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 155, 154, 154),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'signika'),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Location",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'signika'),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      isLocation
                          ? const Text(
                              "Allowed",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'signika',
                                  letterSpacing: 2.0),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                _askLocation();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor:
                                    const Color.fromARGB(255, 8, 182, 14),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  "Allow",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'signika',
                                      letterSpacing: 2.0),
                                ),
                              ))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Camera",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'signika'),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      isCamera
                          ? const Text(
                              "Allowed",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'signika',
                                  letterSpacing: 2.0),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                _askCameraPermission();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor:
                                    const Color.fromARGB(255, 8, 182, 14),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  "Allow",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'signika',
                                      letterSpacing: 2.0),
                                ),
                              ))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                          "Battery Settings",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'signika'),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      isAllSettings
                          ? const Text(
                              "Allowed",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'signika',
                                  letterSpacing: 2.0),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                _askOpenSettings();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor:
                                    const Color.fromARGB(255, 8, 182, 14),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  "Allow",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'signika',
                                      letterSpacing: 2.0),
                                ),
                              ))
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isCamera & isLocation & isAllSettings
                      ? ElevatedButton(
                          onPressed: () {
                            Get.offNamed(GetRoutes.home);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 105, 147)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Text(
                              "Next",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'signika',
                                  letterSpacing: 2.0),
                            ),
                          ))
                      : Text('')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _askCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
      _permissionStatus = await Permission.camera.status;
      setState(() {
        isCamera = true;
      });
    }
  }

  void _askLocation() async {
    if (await Permission.location.request().isGranted) {
      _permissionStatus = await Permission.location.status;
      {
        if (await Permission.locationAlways.request().isGranted) {
          _permissionStatus = await Permission.locationAlways.status;
          setState(() {
            isLocation = true;
          });
        }
      }
    }
  }

  void _askOpenSettings() async {
    if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
      _permissionStatus = await Permission.ignoreBatteryOptimizations.status;
      setState(() {
        isAllSettings = true;
      });
    }
  }
}
