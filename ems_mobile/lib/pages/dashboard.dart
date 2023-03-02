import 'dart:convert';
import 'package:ems_mobile/auth/change_password.dart';
import 'package:ems_mobile/models/my-attendence.dart';
import 'package:ems_mobile/pages/admin/employee_list.dart';
import 'package:ems_mobile/pages/admin/leave_master.dart';
import 'package:ems_mobile/pages/attendence.dart';
import 'package:ems_mobile/pages/map_track.dart';
import 'package:ems_mobile/pages/roadmap.dart';
import 'package:ems_mobile/pages/view_leave.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ems_mobile/utils/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../routes/routes.dart';
import '../utils/custom_values.dart';
import '../utils/shared_pref.dart';
import 'profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final CalendarController _controller = CalendarController();
  String empNumber = "", userRole = "", empName = "";
  bool hasLeaveApprove = false, hasAdminView = false, hasTrackOption = false;
  List<MyAttendence>? attendanceModel;
  String baseUrl = '';

  getEmpDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    empNumber = preferences.getString("empNumber").toString();
    userRole = preferences.getString("userRole").toString();
    empName = preferences.getString("empName").toString();
    print(empName);
    getAttendence();
    setState(() {});
  }

  getRoleAccess() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String userRole = preferences.getString("userRole").toString();
      print(userRole);
      var response = await http
          .get(Uri.parse('${baseUrl}get-roles.php?role_id=$userRole'));

      print(response.body);
      var result = await json.decode(response.body);

      if (result['success']) {
        if (result['role_details']['leave_approve'] == 'yes') {
          hasLeaveApprove = true;
        } else {
          hasLeaveApprove = false;
        }

        if (result['role_details']['admin_view'] == 'yes') {
          hasAdminView = true;
        } else {
          hasAdminView = false;
        }

        if (result['role_details']['location_access'] == 'yes') {
          hasTrackOption = true;
        } else {
          hasTrackOption = false;
        }
      } else {
        print("error");
        print(response.body);
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  getAttendence() async {
    try {
      var response = await http.post(Uri.parse('${baseUrl}get-attendance.php'),
          body: {"emp_number": empNumber});
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

  getbaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = preferences.getString("baseURL").toString();
    getEmpDetails();
    getRoleAccess();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getbaseURL();
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        drawer: NavigationDrawer(
            empName, empNumber, hasTrackOption, hasLeaveApprove, hasAdminView),
        appBar: AppBar(
          title: const Text(
            'Dashboard',
            style: TextStyle(
              fontFamily: 'signika',
              letterSpacing: 2.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: false,
          backgroundColor: const Color.fromRGBO(0, 105, 147, 1),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 105, 147, 1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Welcome,",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'signika',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2.0,
                                    color: Colors.white)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(empName,
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'signika',
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                            Text(empNumber,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2.0,
                                    color: Colors.white)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                child: Container(
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
                                        MovementLocation(empNumber, date)));
                          },
                          // monthCellBuilder: (context, details) => monthStyle(context,details),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget monthStyle(BuildContext buildContext, MonthCellDetails details) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Center(
          child: Text(
        details.date.day.toString(),
        style: TextStyle(color: Colors.white),
      )),
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

class NavigationDrawer extends StatefulWidget {
  String empName, empNumber;
  bool hasLeaveApprove, hasTrackOption, hasAdminView;
  NavigationDrawer(this.empName, this.empNumber, this.hasTrackOption,
      this.hasLeaveApprove, this.hasAdminView,
      {super.key});

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
          color: primaryColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 80, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                headerWidget(widget.empName, widget.empNumber),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Divider(
                    thickness: 1,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                DrawerItem(
                  name: 'Attendance',
                  icon: Icons.web_rounded,
                  onPressed: () => onItemPressed(context, index: 1),
                ),
                DrawerItem(
                  name: 'Profile',
                  icon: Icons.account_box_rounded,
                  onPressed: () => onItemPressed(context, index: 2),
                ),
                if (widget.hasTrackOption)
                  DrawerItem(
                    name: 'Track on Map',
                    icon: Icons.location_pin,
                    onPressed: () => onItemPressed(context, index: 3),
                  ),
                DrawerItem(
                  name: 'Leaves',
                  icon: Icons.work_off,
                  onPressed: () => onItemPressed(context, index: 4),
                ),
                if (widget.hasLeaveApprove)
                  DrawerItem(
                    name: 'Approve Leave',
                    icon: Icons.checklist_rounded,
                    onPressed: () => onItemPressed(context, index: 5),
                  ),
                if (widget.hasAdminView)
                  DrawerItem(
                    name: 'All Employees',
                    icon: Icons.group,
                    onPressed: () => onItemPressed(context, index: 6),
                  ),
                DrawerItem(
                  name: 'Change Password',
                  icon: Icons.lock,
                  onPressed: () => onItemPressed(context, index: 7),
                ),
                // DrawerItem(
                //   name: 'Service Request',
                //   icon: Icons.miscellaneous_services,
                //   onPressed: () => onItemPressed(context, index: 5),
                // ),
                DrawerItem(
                  name: 'Logout',
                  icon: Icons.logout,
                  onPressed: () => onItemPressed(context, index: 8),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> onItemPressed(BuildContext context, {required int index}) async {
    Navigator.pop(context);

    switch (index) {
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Attendence(widget.empNumber)));
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileScreen(widget.empNumber)));
        break;
      case 3:
        String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MapTrack(widget.empNumber, date)));
        break;
      case 4:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ViewLeave(widget.empName, widget.empNumber)));
        break;

      case 5:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LeaveMaster()));
        break;

      case 6:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EmployeeList()));
        break;

       case 7:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChangePassword(widget.empNumber)));
        break;  

      case 8:
        await SharedPrefs().removeUser();
        Get.offAllNamed(GetRoutes.login);
        break;
      default:
        Navigator.pop(context);
        break;
    }
  }

  Widget headerWidget(String empName, empNumber) {
    // const url =
    //     'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80';
    return Row(
      children: [
        // const CircleAvatar(
        //   radius: 42,
        //   backgroundColor: Colors.white,
        //   child: const CircleAvatar(
        //     radius: 40,
        //     backgroundImage: NetworkImage(url),
        //   ),
        // ),
        // const SizedBox(
        //   width: 00,
        // ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 5,),
            Text(empName,
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            Text(empNumber,
                style: const TextStyle(fontSize: 16, color: Colors.white)),
          ],
        )
      ],
    );
  }
}
