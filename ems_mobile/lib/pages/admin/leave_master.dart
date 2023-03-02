import 'dart:convert';

import 'package:ems_mobile/models/admin/all_leaves.dart';
import 'package:ems_mobile/pages/admin/leave_approve.dart';
import 'package:ems_mobile/utils/custom_values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LeaveMaster extends StatefulWidget {
  const LeaveMaster({super.key});

  @override
  State<LeaveMaster> createState() => _LeaveMasterState();
}

class _LeaveMasterState extends State<LeaveMaster> {
  bool hasLeaves = false;
  List<AllLeaves>? leavesModel;
  String baseUrl = '';

  getbaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = preferences.getString("baseURL").toString();
    fetchLeaves();
    setState(() {});
  }
  

  fetchLeaves() async{
     try {
      var response = await http.get(Uri.parse(
          '${baseUrl}get-all-leaves.php'));
      print(response.body);
      String res = response.body.toString().trim();
      print(res);
      if (res == '{"error":"No Leaves Found"}') {
        hasLeaves = false;
        print("no leave");
      } else if (res == '{"success":false}') {
        hasLeaves = false;
        print("Error");
      } else {
        leavesModel = jsonDecode(response.body)
            .map((item) => AllLeaves.fromJson(item))
            .toList()
            .cast<AllLeaves>();
        hasLeaves = true;
      }
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
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
        backgroundColor: primaryColor,
        title: const Text("Leave Master"),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              const SizedBox(height: 10,),
              leavesModel == null
                ? hasLeaves == false
                    ? const Center(
                        child: Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Text(
                          "No Leave Records Found",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ))
                    : const Padding(
                        padding: EdgeInsets.only(top: 200),
                        child: SpinKitFadingCircle(
                          color: Colors.black,
                          size: 100.0,
                        ),
                      )
                : getLeaves()
            ],
          ),
        ),
      ),
    );
  }
  Widget getLeaves() {
    return Expanded(
      child: ListView.builder(
          itemCount: leavesModel!.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                               LeaveApprove(leavesModel![index].id.toString())));
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 105, 147, 1),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${leavesModel![index].empName}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'signika',
                                  letterSpacing: 1.0),
                            ),
                            Text(
                              "${leavesModel![index].empNumber}",
                              style: const TextStyle(
                                color: Colors.white, 
                                fontFamily: 'signika', 
                                fontWeight: FontWeight.w600, 
                                letterSpacing: 1.0,
                                fontSize: 14
                              ),
                            ),
                            Text(
                              "${leavesModel![index].fromDate} To ${leavesModel![index].toDate}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                  fontFamily: 'signika'),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${leavesModel![index].noOfDays}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 23,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'signika'),
                                  ),
                                  const Text(
                                    "Days",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14, fontFamily: 'signika', fontWeight: FontWeight.w600, letterSpacing: 1.0),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 5,),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}