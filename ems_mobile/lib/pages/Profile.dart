import 'dart:convert';
import 'package:ems_mobile/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/custom_values.dart';

class ProfileScreen extends StatefulWidget {
  String empNumber;
  ProfileScreen(this.empNumber, {super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? profileModel;
  double screenHeight = 0;
  bool isOffical = false, isPersonal = false, isaddress = false;

  ImageProvider imageProvider = AssetImage('assets/user.png');
  String baseUrl = '';

  getbaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = preferences.getString("baseURL").toString();
    getProfile();
    setState(() {});
  }

            

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getbaseURL();
  }

  getProfile() async {
    try {
      var response = await http.get(Uri.parse(
          '${baseUrl}get-profile.php?emp_number=${widget.empNumber}'));
      var result = await json.decode(response.body);
      print(response.body);
      if (result['success']) {
        profileModel = Profile.fromJson(result['emp_details']);
        print(result['emp_details']);
        print(profileModel!.empName);
        if (profileModel!.photoFilePath != null) {
              imageProvider = NetworkImage(
                  "${baseUrl}employee_profile/${profileModel!.photoFilePath}");
            }
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

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 235, 234, 234),
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(0, 105, 147, 1),
            title: const Text(
              "PROFILE",
              style: TextStyle(
                letterSpacing: 2.0,
                fontFamily: 'Signika',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            child: SafeArea(
                child: Column(
              children: <Widget>[
                profileModel == null
                    ? const SpinKitFadingCircle(
                        color: Colors.black,
                        size: 100.0,
                      )
                    : Column(children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: screenHeight / 7,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(0, 105, 147, 1),
                              ),
                            ),
                            Positioned(
                              top: screenHeight / 15,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 235, 234, 234),
                                    shape: BoxShape.circle),
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundImage:
                                      imageProvider,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Text(
                          profileModel!.empName.toString(),
                          style: const TextStyle(
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(0, 105, 147, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Employee Name',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Signika',
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  Text(
                                    profileModel!.empName.toString(),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Signika',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Employee Number',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Signika',
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  Text(
                                    profileModel!.empNumber.toString(),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Signika',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Bio Reference Number',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Signika',
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  Text(
                                    profileModel!.bioRefNo.toString(),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Signika',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Department',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Signika',
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  Text(
                                    profileModel!.department.toString(),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Signika',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Sub Department',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Signika',
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  Text(
                                    profileModel!.subDepartment.toString(),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Signika',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Designation',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Signika',
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  Text(
                                    profileModel!.designation.toString(),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Signika',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(0, 105, 147, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (isOffical) {
                                        isOffical = false;
                                      } else {
                                        isOffical = true;
                                      }
                                      setState(() {});
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("OFFICIAL DETAILS",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: 'Signika',
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 1.0,
                                                color: Colors.white)),
                                        isOffical
                                            ? const Icon(
                                                Icons.keyboard_arrow_up,
                                                size: 30,
                                                color: Colors.white,
                                              )
                                            : const Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                      ],
                                    ),
                                  ),
                                  isOffical
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'PLANT NAME',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Signika',
                                                color: Colors.grey[400],
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              profileModel!.plantName
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Signika',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'OFFICIAL EMAIL',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Signika',
                                                color: Colors.grey[400],
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              profileModel!.officialEmail
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Signika',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'DATE OF JOINING',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Signika',
                                                color: Colors.grey[400],
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              profileModel!.dateOfJoining
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Signika',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              'SALARY',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Signika',
                                                color: Colors.grey[400],
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              profileModel!.salary.toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Signika',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  const Divider(
                                    color: Colors.white,
                                    thickness: 1,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (isPersonal) {
                                        isPersonal = false;
                                      } else {
                                        isPersonal = true;
                                      }
                                      setState(() {});
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "PERSONAL DETAILS",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Signika',
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 1.0,
                                              color: Colors.white),
                                        ),
                                        isPersonal
                                            ? const Icon(
                                                Icons.keyboard_arrow_up,
                                                size: 30,
                                                color: Colors.white,
                                              )
                                            : const Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                      ],
                                    ),
                                  ),
                                  if (isPersonal)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'PERSONAL E-MAIL',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Signika',
                                            color: Colors.grey[400],
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        Text(
                                          profileModel!.personalEmail
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Signika',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'MOBILE NUMBER 1',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Signika',
                                            color: Colors.grey[400],
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        Text(
                                          profileModel!.mobileNo1.toString(),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Signika',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'MOBILE NUMBER 2',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Signika',
                                            color: Colors.grey[400],
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        Text(
                                          profileModel!.mobileNo2.toString(),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Signika',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          'SPOUSE NAME',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Signika',
                                            color: Colors.grey[400],
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        Text(
                                          profileModel!.spouseName.toString(),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Signika',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    const SizedBox(),
                                  const SizedBox(),
                                  const Divider(
                                    color: Colors.white,
                                    thickness: 1,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (isaddress) {
                                        isaddress = false;
                                      } else {
                                        isaddress = true;
                                      }
                                      setState(() {});
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "ADDRESS INFORMATION",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Signika',
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 1.0,
                                              color: Colors.white),
                                        ),
                                        isaddress
                                            ? const Icon(
                                                Icons.keyboard_arrow_up,
                                                size: 30,
                                                color: Colors.white,
                                              )
                                            : const Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                      ],
                                    ),
                                  ),
                                  isaddress
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'COMMUNICATION ADDRESS',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Signika',
                                                color: Colors.grey[400],
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              profileModel!
                                                  .communicationAddress1
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Signika',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              profileModel!
                                                  .communicationAddress2
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Signika',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              profileModel!
                                                  .communicationAddress3
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Signika',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              profileModel!.communicationTaluk
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Signika',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              profileModel!
                                                  .communicationDistrict
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Signika',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              profileModel!.communicationState
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Signika',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              "${profileModel!.communicationCountry.toString()} - ${profileModel!.communicationPincode.toString()}",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Signika',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Divider(
                                                thickness: 1,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'PERMANENT ADDRESS',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Signika',
                                                color: Colors.grey[400],
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              profileModel!.permanentAddress1
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Signika',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              profileModel!.permanentAddress2
                                                  .toString(),
                                              style: const TextStyle(
                                                fontFamily: 'Signika',
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              profileModel!.permanentAddress3
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Signika',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              profileModel!.permanentTaluk
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Signika',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              profileModel!.permanentDistrict
                                                  .toString(),
                                              style: const TextStyle(
                                                fontFamily: 'Signika',
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              profileModel!.permanentState
                                                  .toString(),
                                              style: const TextStyle(
                                                fontFamily: 'Signika',
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            Text(
                                              "${profileModel!.permanentCountry.toString()} - ${profileModel!.communicationPincode.toString()}",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Signika',
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
              ],
            )),
          ),
        ));
  }
}
