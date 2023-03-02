import 'dart:convert';

import 'package:ems_mobile/pages/leave_apply.dart';
import 'package:ems_mobile/models/leaves.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/custom_values.dart';

class ViewLeave extends StatefulWidget {
  String empName, empNumber;
  ViewLeave(this.empName, this.empNumber, {super.key});

  @override
  State<ViewLeave> createState() => _ViewLeaveState();
}

class _ViewLeaveState extends State<ViewLeave> {
  double screenHeight = 0;
  List<Leaves>? leavesModel;
  bool hasLeaves = true;
  String baseUrl = '';

  getbaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = preferences.getString("baseURL").toString();
    fetchLeaves();
    setState(() {});
  }

  Future<void> fetchLeaves() async {
    try {
      var response = await http.get(Uri.parse(
          '${baseUrl}view-leaves.php?emp_number=${widget.empNumber}'));
      print(response.body);
      String res = response.body.toString().trim();
      print(res);
      if (res == '{"message":"No Leave Found"}') {
        hasLeaves = false;
        print("no leave");
      } else if (res == '{"success":false}') {
        hasLeaves = false;
        print("Error");
      } else {
        print("object");
        leavesModel = jsonDecode(response.body)
            .map((item) => Leaves.fromJson(item))
            .toList()
            .cast<Leaves>();
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
    super.initState();
     getbaseURL();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 105, 147, 1),
        title: const Text("View Leave",
        style: TextStyle(
          fontFamily: 'signika',
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 30),
              height: screenHeight / 5,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 105, 147, 1),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ApplyLeave(widget.empName, widget.empNumber)));
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            )),
                        child: const Icon(
                          Icons.add,
                          size: 35,
                          color: Color.fromRGBO(0, 105, 147, 1),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: const [
                        Text(
                          "Your Leaves",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              letterSpacing: 1.0,
                              fontFamily: 'signika',
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 5,
              ),
              child: Text(
                "Recent Leaves",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'signika', letterSpacing: 1.0),
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 179, 177, 177),
              thickness: 1,
            ),
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
          ]),
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
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(0, 105, 147, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
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
                            "${leavesModel![index].leaveType}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'signika',
                                letterSpacing: 1.0),
                          ),
                          Text(
                            "${leavesModel![index].leaveDescription}",
                            style: const TextStyle(color: Colors.white, fontFamily: 'signika', fontWeight: FontWeight.w600, letterSpacing: 1.0),
                          ),
                          Text(
                            "${leavesModel![index].fromDate} - ${leavesModel![index].toDate}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
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
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'signika'),
                                ),
                                Text(
                                  "Days",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14, fontFamily: 'signika', fontWeight: FontWeight.w600, letterSpacing: 1.0),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 5,),
                          if(leavesModel![index].status=='0')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey
                            ),
                            child: const Text("Pending",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                          ),
                          if(leavesModel![index].status=='1')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green
                            ),
                            child: const Text("Approved",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                          ),
                          if(leavesModel![index].status=='2')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red
                            ),
                            child: const Text("Declined",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
