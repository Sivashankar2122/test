import 'dart:convert';
import 'package:ems_mobile/models/track_check_in_out.dart';
import 'package:ems_mobile/pages/map_track.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/custom_values.dart';

class MovementLocation extends StatefulWidget {
  String empNumber,date;
  MovementLocation(this.empNumber,this.date, {super.key});

  @override
  State<MovementLocation> createState() => _MovementLocationState();
}

class _MovementLocationState extends State<MovementLocation> {
  int currentStep = 0;
  DateTime currentDate = DateTime.now();
  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now();
  List<TrackCheckInOut>? roadmapModel;
  bool hasMovement = true;
  String date = '';
  String baseUrl = '';

  getbaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = preferences.getString("baseURL").toString();
    
    fetchRoadMap();
    setState(() {});
  }

  Future<void> fetchRoadMap() async {
    try {
      print(widget.date);
      var response = await http.get(Uri.parse(
          '${baseUrl}view-roadmap.php?emp_number=${widget.empNumber}&date=${widget.date}'));
      String res = response.body.toString().trim();

      
      if (res == '{"message":"No Movement Found"}') {
        print("No Movement");
        hasMovement = false;
      } else if (res == '{"success":false}') {
        hasMovement = false;
      } else {
        roadmapModel = jsonDecode(response.body)
            .map((item) => TrackCheckInOut.fromJson(item))
            .toList()
            .cast<TrackCheckInOut>();
        hasMovement = true;
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
          title: const Text("Movement Location"),
          backgroundColor: Color.fromRGBO(0, 105, 147, 1),
          actions: [
             InkWell(
               onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                MapTrack(widget.empNumber,widget.date)));
               },
               child: const Icon(Icons.map_rounded)),
             const SizedBox(width: 20,)
          ],
        ),
        body: Column(
          mainAxisAlignment: roadmapModel == null
           ? MainAxisAlignment.center
           : MainAxisAlignment.start,
          children: [
            hasMovement
                ? roadmapModel == null
                    ? const SpinKitFadingCircle(
                        color: Colors.black,
                        size: 100.0,
                      )
                    : getRoadMap()
                : const Center(
                    child: Text(
                      'No Record Found',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  )
          ],
        ));
  }

  Widget getRoadMap() {
    try {
      return Expanded(
        child: ListView.builder(
            itemCount: roadmapModel!.length,
            itemBuilder: (context, index) {
              checkInDate = DateFormat("yyyy-MM-dd H:mm:ss")
                  .parse(roadmapModel![index].checkIn.toString());
              date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
              if (roadmapModel![index].checkOut != null) {
                checkOutDate = DateFormat("yyyy-MM-dd H:mm:ss")
                    .parse(roadmapModel![index].checkOut.toString());
              }
              return Column(
                children: [
                  if (roadmapModel![index].checkOut != null)
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              width: 2,
                              height: 50,
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
                              height: 50,
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
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        "${baseUrl}attendence_image/$date/${widget.empNumber}/${roadmapModel![index].checkOutImage}"),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${checkOutDate.hour} : ${checkOutDate.minute}',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                          'Checked Out',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          roadmapModel![index]
                                              .checkoutAddress
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
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
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            width: 2,
                            height: 50,
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
                            height: 50,
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
                                BoxShadow(blurRadius: 10, color: Colors.black26)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                      "${baseUrl}attendence_image/$date/${widget.empNumber}/${roadmapModel![index].checkInImage}"),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${checkInDate.hour} : ${checkInDate.minute}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Checked In',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        roadmapModel![index]
                                            .checkinAddress
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
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
