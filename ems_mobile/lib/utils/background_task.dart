import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'custom_values.dart';

initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

onStart(ServiceInstance service) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String empNumber = preferences.getString("empNumber").toString();
  String baseUrl = preferences.getString("baseURL").toString();
  int locationInterval =
      int.parse(preferences.getString("locationInterval").toString());

  DartPluginRegistrant.ensureInitialized();
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "GTN Info",
      content: "Location Tracking On",
    );
  }

  Timer.periodic(Duration(minutes: locationInterval), (timer) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "GTN Info",
        content: "Location Tracking On",
      );
    }

    Position userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var response =
        await http.post(Uri.parse('${baseUrl}add-location.php'), body: {
      "emp_number": empNumber,
      "latitude": userLocation.latitude.toString(),
      "longitude": userLocation.longitude.toString(),
    });
    print(response.body);
  });
}
