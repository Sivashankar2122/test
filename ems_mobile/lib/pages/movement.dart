import 'dart:convert';

import 'package:ems_mobile/models/my-movement.dart';
import 'package:ems_mobile/utils/custom_values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Movements extends StatefulWidget {
  String empNumber, date;
  Movements(this.empNumber, this.date, {super.key});

  @override
  State<Movements> createState() => _MovementsState();
}

class _MovementsState extends State<Movements> {
  List<MyMovements>? apiMovements;
  bool hasError = false;
  String baseUrl = '', errormsg = '';

  getbaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance(); 
    baseUrl = preferences.getString("baseURL").toString();

    fetchRoadMap();
    setState(() {});
  }

  Future<void> fetchRoadMap() async {
    try {
      print(widget.date);
      var response = await http.post(Uri.parse(
          'http://10.10.186.48/gtn_info_ms_sql/get-movements.php'),body: {
            "emp_number":widget.empNumber,
            "date":widget.date
          });
      var result = await json.decode(response.body);
      print(response.body);

      if (result['success']) {
        apiMovements = result['movements']
            .map((item) => MyMovements.fromJson(item))
            .toList()
            .cast<MyMovements>();
        hasError = false;
      } else {
        hasError = true;
        errormsg = result['message'];
      }
    } catch (e) {
      if (kDebugMode) {
        hasError = true;
        errormsg = e.toString();
        print(e);
      }
    }
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
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('Movements'),
        ),
        body: Column(
          mainAxisAlignment: apiMovements == null
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            !hasError
                ? apiMovements == null
                    ? const SpinKitFadingCircle(
                        color: Colors.black,
                        size: 100.0,
                      )
                    : getRoadMap()
                : Center(
                    child: Text(
                      errormsg,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  )
          ],
        ));
  }

  Widget getRoadMap() {
    try {
      return Expanded(
        child: ListView.builder(
            itemCount: apiMovements!.length,
            itemBuilder: (context, index) {
              DateTime logOn = DateFormat("yyyy-MM-dd H:mm:ss")
                  .parse(apiMovements![index].logOn.toString());
              // date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
              // if (roadmapModel![index].checkOut != null) {
              //   checkOutDate = DateFormat("yyyy-MM-dd H:mm:ss")
              //       .parse(roadmapModel![index].checkOut.toString());
              // }
              return Column(
                children: [
                  if (true)
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              width: 2,
                              height: 35,
                              color: Colors.black,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 5, right: 5),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(0, 105, 147, 1),
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 35,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        width: 4,
                                        color: Color.fromRGBO(0, 105, 147, 1))),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10, color: Colors.black26)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 15),
                              child: Row(
                                children: [

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${logOn.hour}: ${logOn.minute}',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${apiMovements![index].type}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        // Text(
                                        //   "${apiMovements![index].latitude},${apiMovements![index].longitude}",
                                        //   style: const TextStyle(
                                        //     fontSize: 15,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            }),
      );
    } catch (e) {
      print(e.toString());
      return Text(e.toString());
    }
  }
}
