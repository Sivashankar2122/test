import 'dart:convert';

import 'package:ems_mobile/models/profile.dart';
import 'package:ems_mobile/pages/Profile.dart';
import 'package:ems_mobile/utils/custom_values.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

import '../../models/my-attendence.dart';
import '../roadmap.dart';

class EmpDetail extends StatefulWidget {
  String empId, empNumber, empName, empDept, empProfile;
  EmpDetail(
      this.empId, this.empNumber, this.empName, this.empDept, this.empProfile,
      {super.key});

  @override
  State<EmpDetail> createState() => EmpDetailState();
}

class EmpDetailState extends State<EmpDetail> {
  final CalendarController _controller = CalendarController();
  List<MyAttendence>? attendanceModel;
   String baseUrl = '';

  getbaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = preferences.getString("baseURL").toString();
    getAttendence();
    getProfileImage();
    setState(() {});
  }


  ImageProvider imageProvider = AssetImage('assets/user.png');

  getProfileImage() {
    if (widget.empProfile != 'null') {
      imageProvider = NetworkImage("${baseUrl}employee_profile/${widget.empProfile}");
    }
    setState(() {});
  }

  getAttendence() async {
    try {
      var response = await http.post(Uri.parse('${baseUrl}get-attendance.php'),
          body: {"emp_number": widget.empNumber});
      var result = await json.decode(response.body);

      if (result['success']) {
        attendanceModel = result['attendance']
            .map((item) => MyAttendence.fromJson(item))
            .toList()
            .cast<MyAttendence>();
        print(response.body);
      } else {
        print(result['message']);
      }
    } catch (e) {
      print(e);
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Employee Detail',
          style: TextStyle(
            fontFamily: 'signika',
            letterSpacing: 2.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 105, 147, 1),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontFamily: 'signika',
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.empName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'signika',
                                  letterSpacing: 2.0,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "ID",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontFamily: 'signika',
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.empNumber,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'signika',
                                  letterSpacing: 2.0,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Department",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontFamily: 'signika',
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.empDept,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'signika',
                                  letterSpacing: 2.0,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 235, 236, 240),
                                    shape: BoxShape.circle),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      imageProvider,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(widget.empNumber)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "DETAILED PROFILE",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontFamily: 'signika',
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.grey[400],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Container(
              //       decoration: BoxDecoration(
              //           color: const Color.fromRGBO(0, 105, 147, 1),
              //           borderRadius: BorderRadius.circular(10)),
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              //         child: Column(
              //           children: [
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text('No of Leaves Taken',
              //                 style: TextStyle(
              //                     color: Colors.grey[400],
              //                     fontFamily: 'signika',
              //                     letterSpacing: 1.0,
              //                     fontSize: 15,
              //                     fontWeight: FontWeight.w600,)),
              //                 Text('8',
              //                 style: TextStyle(
              //                     color: Colors.white,
              //                     fontFamily: 'signika',
              //                     letterSpacing: 1.0,
              //                     fontSize: 20,
              //                     fontWeight: FontWeight.w600,)),
              //               ],
              //             ),
              //             const Divider(
              //                 indent: 3,
              //                 endIndent: 3,
              //                 thickness: 0.8,
              //                 color: Colors.white),
              //             Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text('No of Leaves Remaining',
              //                   style: TextStyle(
              //                       color: Colors.grey[400],
              //                       fontFamily: 'signika',
              //                       letterSpacing: 1.0,
              //                       fontSize: 15,
              //                       fontWeight: FontWeight.w600,)),
              //                   Text('10',
              //                   style: TextStyle(
              //                       color: Colors.white,
              //                       fontFamily: 'signika',
              //                       letterSpacing: 1.0,
              //                       fontSize: 20,
              //                       fontWeight: FontWeight.w600,)),
              //                 ],
              //               ),
              //           ],
              //         ),
              //       ),
              //     ),
              SizedBox(
                height: 10,
              ),

              Container(
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 105, 147, 1),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SfCalendar(
                        viewHeaderStyle: ViewHeaderStyle(
                          backgroundColor: primaryColor,
                          dayTextStyle: const TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                        ),
                        todayHighlightColor: Colors.orange,
                        backgroundColor: primaryColor,
                        view: CalendarView.month,
                        controller: _controller,
                        dataSource: getCalendarDataSource(),
                        headerHeight: 50,
                        todayTextStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        cellBorderColor: primaryColor,
                        selectionDecoration: null,
                        showNavigationArrow: true,
                        headerStyle: const CalendarHeaderStyle(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w600),
                        ),
                        monthViewSettings: const MonthViewSettings(
                            showTrailingAndLeadingDates: false,
                            monthCellStyle: MonthCellStyle(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 15))),
                                    onSelectionChanged: (calendarSelectionDetails) {
                            DateTime selectedDate = DateTime.parse(
                                calendarSelectionDetails.date.toString());
                            String date =
                                DateFormat("yyyy-MM-dd").format(selectedDate);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MovementLocation(widget.empNumber,date)));
                          },
                        // monthCellBuilder: (context, details) => monthStyle(context,details),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _DataSource getCalendarDataSource() {
    final List<Appointment> appointments = <Appointment>[];

    if (attendanceModel != null) {
      for (var i = 0; i < attendanceModel!.length; i++) {
        DateTime attendanceDate =
            DateFormat('yyyy-MM-dd').parse(attendanceModel![i].date.toString());
        print(attendanceDate.toString());

        //morning
        appointments.add(Appointment(
            startTime: attendanceDate,
            endTime: attendanceDate,
            color: "${attendanceModel![i].morning}" == "1"
                ? Colors.green
                : Colors.red));

        //afternon
        appointments.add(Appointment(
            startTime: attendanceDate,
            endTime: attendanceDate,
            color: "${attendanceModel![i].afternoon}" == "1"
                ? Colors.green
                : Colors.red));
      }
    }

    return _DataSource(appointments);
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
