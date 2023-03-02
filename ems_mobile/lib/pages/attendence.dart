import 'dart:convert';
import 'dart:io';
import 'package:ems_mobile/models/check_in_out.dart';
import 'package:ems_mobile/pages/movement.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:http/http.dart' as http;
import '../utils/background_task.dart';
import '../utils/custom_values.dart';
import 'roadmap.dart';

class Attendence extends StatefulWidget {
  String empNumber;
  Attendence(this.empNumber, {super.key});

  @override
  State<Attendence> createState() => _AttendenceState();
}

class _AttendenceState extends State<Attendence> {
  double screenHeight = 0;
  double screenWidth = 0;
  bool isCheckIn = false,
      isCheckOut = false,
      isUploading = false,
      isTodayChecked = false,
      hasOneCheck = false,
      isLeave = false;
  var locationMessage = "Loading";
  late DateTime checkIn, checkOut;
  String checkInTime = "- - : - -", checkOutTime = "- - : - -";
  CheckInOut? checkInOut;
  late File image;
  String currentDate  = "${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}%";
  String latitude = '', longitude = '';
  bool hasLocation = false;
  String locationInterval = '';
  String baseUrl = '';

  getbaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = preferences.getString("baseURL").toString();
    getRoleAccess();
    getCurrentLocation();
    setState(() {});
  }

  Future<void> chooseImageFromCamera(String checkType) async {
    isUploading = true;
    setState(() {});
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
        preferredCameraDevice: CameraDevice.front);

    if (pickedFile != null) {
      image = File(pickedFile.path);

      var isUploaded = await uploadImage(image, widget.empNumber, checkType);

      if (isUploaded) {
        print("Uploaded");
      } else {
        print("Something went wrong");
      }
      print("image selected");
    }
  }

  Future<bool> uploadImage(
      File image, String empNumber, String checkType) async {
    try {
      final bytes = image.readAsBytesSync();

      final response = await http.post(Uri.parse("${baseUrl}upload_image.php"),
          body: {"image": base64Encode(bytes), "empNumber": empNumber});
      final message = jsonDecode(response.body);
      print(message);
      if (message['status'] == 1) {
        if (checkType == "checkIn") {
          addCheckIn(message['image_file'].toString());
        } else if (checkType == "checkOut") {
          addCheckOut(message['image_file'].toString());
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  getCheckInOut() async {
    try {
      print(currentDate);
      var response = await http.get(Uri.parse(
          '${baseUrl}get-check-in-out.php?emp_number=${widget.empNumber}&date=$currentDate'));
      var result = await json.decode(response.body);
      print(response.body);
      if (result['success']) {
        checkInOut = CheckInOut.fromJson(result['check-in-out']);

        if (checkInOut!.checkIn == null) {
          checkInTime = "- - : - -";
          isCheckIn = true;
        } else {
          checkIn = DateFormat("yyyy-MM-dd H:m:ss")
              .parse(checkInOut!.checkIn.toString());
          checkInTime = "${checkIn.hour}:${checkIn.minute}";
          isCheckIn = false;
        }

        if (checkInOut!.checkOut == null) {
          checkOutTime = "- - : - -";
          isCheckOut = true;
        } else {
          checkOut = DateFormat("yyyy-MM-dd H:m:ss")
              .parse(checkInOut!.checkOut.toString());
          checkOutTime = "${checkOut.hour}:${checkOut.minute}";
          isCheckOut = false;
        }

        if (checkInOut!.checkIn != null && checkInOut!.checkOut != null) {
          isCheckIn = true;
          if (hasOneCheck) {
            isTodayChecked = true;
          } else {
            isTodayChecked = false;
          }
        }
      } else if (result['message'].toString() == "No checkInOut Found") {
        print("No check In found");
        isCheckIn = true;
        isCheckOut = false;
      } else if (result['message'].toString() == "Leave Today") {
        print("No check In found");
        isCheckIn = false;
        isCheckOut = false;
        isLeave = true;
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

  addLocation() async {
    try {
      String date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
      var response =
          await http.post(Uri.parse('${baseUrl}add-location.php'), body: {
        "emp_number": widget.empNumber,
        "date": date,
        "latitude": latitude,
        "longitude": longitude,
      });

      var accessResult = await json.decode(response.body);

      if (accessResult['success']) {
        getCheckInOut();
      } else {
        print("error");
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  addCheckIn(String imagePath) async {
    try {
      var response =
          await http.post(Uri.parse('${baseUrl}check-in.php'), body: {
        "emp_number": widget.empNumber,
        "checkin_latitude": latitude,
        "checkin_longitude": longitude,
        "checkin_address": locationMessage,
        "check_in_image": imagePath,
      });

      var accessResult = await json.decode(response.body);

      if (accessResult['success']) {
        getCheckInOut();
        if (hasLocation) {
          addLocation();
          final service = FlutterBackgroundService();
          await initializeBackgroundService();
          service.startService();
        }
        isUploading = false;
        setState(() {});
      } else {
        print("error");
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  addCheckOut(String imagePath) async {
    try {
      var response =
          await http.post(Uri.parse('${baseUrl}check-out.php'), body: {
        "checkout_latitude": latitude,
        "checkout_longitude": longitude,
        "checkout_address": locationMessage,
        "emp_number": widget.empNumber,
        "check_out_image": imagePath,
        "id": checkInOut!.id.toString(),
      });

      var accessResult = await json.decode(response.body);

      if (accessResult['success']) {
        getCheckInOut();
        if (hasLocation) {
          addLocation();
          final service = FlutterBackgroundService();
          await initializeBackgroundService();
          service.invoke("stopService");
        }
        isUploading = false;
        setState(() {});
      } else {
        print("error");
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  void getCurrentLocation() async {
    try {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemark[0];
      locationMessage =
          '${place.street},${place.subAdministrativeArea}, ${place.locality},${place.country}';
      print(locationMessage);
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

  getRoleAccess() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String userRole = preferences.getString("userRole").toString();
      print(userRole);
      var response = await http
          .get(Uri.parse('${baseUrl}get-roles.php?role_id=$userRole'));

      var accessResult = await json.decode(response.body);

      if (accessResult['success']) {
        if (accessResult['role_details']['one_check_in_out'] == 'yes') {
          hasOneCheck = true;
        } else {
          hasOneCheck = false;
        }
        if (accessResult['role_details']['location_access'] == 'yes') {
          hasLocation = true;
          locationInterval =
              accessResult['role_details']['location_interval'].toString();
          preferences.setString(
              "locationInterval", locationInterval.toString());
        }

        getCheckInOut();
      } else {
        print("error");
        print(response.body);
      }
    } catch (e) {
      print(e);
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
    screenWidth = MediaQuery.of(context).size.width;
    Color primary = const Color.fromRGBO(0, 105, 147, 1);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text(
          "Attendence",
          style: TextStyle(
              fontFamily: 'signika',
              letterSpacing: 2.0,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        // InkWell(
                        //   onTap: chooseImageFromCamera,
                        //   child: Container(
                        //     padding: const EdgeInsets.all(30),
                        //     decoration: const BoxDecoration(
                        //       color: Color.fromRGBO(217, 217, 217, 1),
                        //       shape: BoxShape.circle,
                        //     ),
                        //     child: const Icon(
                        //       Icons.photo_camera,
                        //       size: 40,
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(
                        //   width: 20,
                        // ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text: DateTime.now().day.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenWidth / 15,
                                        fontFamily: 'signika',
                                      ),
                                      children: [
                                    TextSpan(
                                        text: DateFormat(' MMMM yyyy')
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth / 20,
                                            fontFamily: 'signika',
                                            letterSpacing: 1.0,
                                            fontWeight: FontWeight.w600))
                                  ])),
                              StreamBuilder(
                                  stream: Stream.periodic(
                                      const Duration(seconds: 1)),
                                  builder: (context, snapshot) {
                                    return Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        DateFormat('hh:mm:ss a')
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                            fontFamily: 'signika',
                                            fontWeight: FontWeight.w600,
                                            fontSize: screenWidth / 20,
                                            color: const Color.fromARGB(
                                                209, 255, 255, 255)),
                                      ),
                                    );
                                  }),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Current Location",
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 15,
                                    fontFamily: 'signika',
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                locationMessage,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: 'signika',
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Daily Check",
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600),
                ),
                if(!isLeave)
                !isTodayChecked
                    ? Column(
                        children: [
                          if (!isUploading)
                            isCheckIn
                                ? Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Builder(
                                      builder: (context) {
                                        final GlobalKey<SlideActionState> key =
                                            GlobalKey();

                                        return InkWell(
                                          onTap: () {
                                            // Workmanager().registerPeriodicTask(
                                            //   widget.empNumber,
                                            //   "fetchBackground",
                                            //   frequency: Duration(minutes: 15),
                                            // );
                                          },
                                          child: SlideAction(
                                              height: 60,
                                              sliderButtonIconPadding: 10,
                                              sliderButtonIcon: Icon(
                                                Icons.arrow_forward_ios,
                                                color: primary,
                                              ),
                                              text: "Swipe to Check In",
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: screenWidth / 20,
                                                  fontFamily: 'signika',
                                                  letterSpacing: 2.0,
                                                  fontWeight: FontWeight.w600),
                                              outerColor: primary,
                                              innerColor: const Color.fromRGBO(
                                                  217, 217, 217, 1),
                                              key: key,
                                              onSubmit: () {
                                                chooseImageFromCamera(
                                                    "checkIn");
                                              }),
                                        );
                                      },
                                    ),
                                  )
                                : const SizedBox(),
                          if (isUploading)
                            const SpinKitFadingCircle(
                              color: Colors.black,
                              size: 100.0,
                            ),
                          if (!isUploading)
                            isCheckOut
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 5),
                                    child: Builder(
                                      builder: (context) {
                                        final GlobalKey<SlideActionState> key =
                                            GlobalKey();

                                        return SlideAction(
                                            height: 60,
                                            sliderButtonIconPadding: 10,
                                            sliderButtonIcon: Icon(
                                              Icons.arrow_forward_ios,
                                              color: primary,
                                            ),
                                            text: "Swipe to Check Out",
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: screenWidth / 20,
                                                fontFamily: 'Roboto'),
                                            outerColor: primary,
                                            innerColor: const Color.fromRGBO(
                                                217, 217, 217, 1),
                                            key: key,
                                            onSubmit: () {
                                              chooseImageFromCamera("checkOut");
                                            });
                                      },
                                    ),
                                  )
                                : const SizedBox(),
                        ],
                      )
                    : Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Today Check In Check Out Completed",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 10,
                ),
                if(isLeave)
                Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "You are leave Today !",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
                const Divider(thickness: 2, color: Colors.grey),
                const Text(
                  "Movements",
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'signika',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0),
                ),
                const Text(
                  "Today Check In - Out",
                  style: TextStyle(
                      color: Color.fromARGB(255, 114, 113, 113),
                      fontFamily: 'signika',
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 105, 147, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      )
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "IN",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontFamily: 'signika',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0),
                        ),
                        Text(
                          "${checkInTime}",
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontFamily: 'signika',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),

                  //
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 105, 147, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      )
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "OUT",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontFamily: 'signika',
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${checkOutTime}",
                          style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontFamily: 'signika',
                              fontWeight: FontWeight.w600),
                        ),
                      ]),

                  //
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                   Movements(widget.empNumber,date)));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 10, bottom: 12),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 105, 147, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(2, 2),
                            )
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: const Text(
                          "All Movements",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'signika',
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
