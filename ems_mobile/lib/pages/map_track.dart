import 'dart:async';
import 'dart:convert';
import 'package:ems_mobile/models/getlocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/custom_values.dart';

class MapTrack extends StatefulWidget {
  String empNUmber,date;
  MapTrack(this.empNUmber,this.date, {Key? key}) : super(key: key);

  @override
  State<MapTrack> createState() => _MapTrackState();
}

class _MapTrackState extends State<MapTrack> {
  List<GetLocation>? locationModel;
  List<LatLng> latLng = [
    // LatLng(11.4966453, 77.2775813),
    // LatLng(11.4952228, 77.2783001),
    // LatLng(11.4951004, 77.2788303)
  ];
  bool hasLocation = false, isLoading = true;
  DateTime currentDateTime = DateTime.now();
  late BitmapDescriptor customIcon;
  int lastIndex = 0;
  final Set<Polyline> polyline = {};
  final Completer<GoogleMapController> _controller = Completer();
  final Map<String, Marker> _markers = {};
  int totalDistance = 0;
  String baseUrl = '';

  getbaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = preferences.getString("baseURL").toString();
    fetchLocation();
    setState(() {});
  }

  Future<void> fetchLocation() async {
    try {
      isLoading = true;
      String url =
          '${baseUrl}location.php?emp_number=${widget.empNUmber}&date=${widget.date}';
      var response = await http.get(Uri.parse(url));
      print(response.body);
      locationModel = jsonDecode(response.body)
          .map((item) => GetLocation.fromJson(item))
          .toList()
          .cast<GetLocation>();
      _markers.clear;
      totalDistance = 0;
      latLng.clear();
      isLoading = false;
      for (int i = 0; i < locationModel!.length; i++) {
        latLng.add(LatLng(double.parse(locationModel![i].latitude.toString()),
            double.parse(locationModel![i].longitude.toString())));

        final marker = Marker(
          markerId: MarkerId(locationModel![i].id.toString()),
          icon: customIcon,
          position: LatLng(double.parse(locationModel![i].latitude.toString()),
              double.parse(locationModel![i].longitude.toString())),
          infoWindow: InfoWindow(
              title: "Emp Number:${locationModel![i].empNumber.toString()}",
              snippet: locationModel![i].updatedAt.toString(),
              onTap: () {}),
          onTap: () {},
        );

        _markers[locationModel![i].id.toString()] = marker;
        lastIndex = i;
        hasLocation = true;
      }

      for (var i = 1; i < locationModel!.length; i++) {
        double lat1 = double.parse(locationModel![i - 1].latitude.toString());
        double lng1 = double.parse(locationModel![i - 1].longitude.toString());
        double lat2 = double.parse(locationModel![i].latitude.toString());
        double lng2 = double.parse(locationModel![i].longitude.toString());
        getDistance(lat1, lng1, lat2, lng2);
      }
      drawPolylines();
      setState(() {});
    } catch (e) {
      hasLocation = false;
      isLoading = false;
      _markers.clear;
      print(e);
    }
  }

  drawPolylines() {
    polyline.add(Polyline(
      polylineId: const PolylineId('1'),
      color: Colors.green,
      width: 5,
      points: latLng,
    ));
  }

  getDistance(double lat1, lng1, lat2, lng2) async {
    double distance = await Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
    totalDistance += distance.round();
    setState(() {});
  }

  // launchMap(lat, long) {
  //   MapsLauncher.launchCoordinates(lat, long);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getbaseURL();
  }

  @override
  Widget build(BuildContext context) {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/map_plot.png')
        .then((icon) {
      setState(() {
        customIcon = icon;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track on Map"),
        backgroundColor: const Color.fromRGBO(0, 105, 147, 1),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                fetchLocation();
              },
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          hasLocation
              ? GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        double.parse(
                            locationModel![lastIndex].latitude.toString()),
                        double.parse(
                            locationModel![lastIndex].longitude.toString())),
                    zoom: 17.5,
                  ),
                  markers: _markers.values.toSet(),
                  polylines: polyline,
                )
              : isLoading
                  ? const SpinKitFadingCircle(
                      color: Colors.black,
                      size: 100.0,
                    )
                  : const Center(
                      child: Text(
                      "No Records Found",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )),
          if (hasLocation)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 202, 202, 202),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "Total Distances Travelled: ${totalDistance / 1000}Km",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            )
        ],
      ),
    );
  }
}
