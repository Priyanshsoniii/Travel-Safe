// ignore_for_file: avoid_print, unused_element, unused_local_variable

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gang/db/db_services.dart';
import 'package:gang/model/contactsm.dart';
import 'package:gang/widgets/home_widgets/CustomCarousel.dart';
import 'package:gang/widgets/home_widgets/custom_appBar.dart';
import 'package:gang/widgets/home_widgets/emergency.dart';
import 'package:gang/widgets/home_widgets/safehome/SafeHome.dart';
import 'package:gang/widgets/live_safe.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // const HomeScreen({super.key});
  int qIndex = 0;
  Position? _curentPosition;
  String? _curentAddress;
  LocationPermission? permission;
  _getPermission() async => await [Permission.sms].request();
  _isPermissionGranted() async => await Permission.sms.status.isGranted;
  String _currentCity = "";
  checkLocationPermission() async {
    bool permissionGranted = await _requestLocationPermission();
    setState(() {
      _locationPermissionGranted = permissionGranted;
    });

    if (_locationPermissionGranted) {
      _getCurrentCity();
    }
  }

  void _getCurrentCity() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          _currentCity = placemark.locality ?? 'Unknown';
        });
        print(_currentCity);
      }
    } catch (e) {
      print('Error getting current city: $e');
    }
  }

  bool _locationPermissionGranted = false;
  Future<bool> _requestLocationPermission() async {
    var status = await Permission.location.request();
    return status == PermissionStatus.granted;
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('Current Location: $position');
      _getCurrentAddress();
      // Handle the obtained location as needed
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  String currentCity = '';

  _getCurrentAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _curentPosition!.latitude, _curentPosition!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        _curentAddress =
            "${place.locality},${place.postalCode},${place.street},";
        print(_curentAddress);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  getRandomQuote() {
    Random random = Random();
    setState(() {
      qIndex = random.nextInt(6);
    });
  }

  getAndSendSms() async {
    List<TContact> contactList = await DatabaseHelper().getContactList();

    String messageBody =
        "https://maps.google.com/?daddr=${_curentPosition!.latitude},${_curentPosition!.longitude}";
    if (await _isPermissionGranted()) {
      for (var element in contactList) {}
    } else {
      Fluttertoast.showToast(msg: "something wrong");
    }
  }

  @override
  void initState() {
    getRandomQuote();
    super.initState();
    _getPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
                child: Container(
                  color: Colors.grey.shade100,
                ),
              ),
              const SizedBox(height: 5),
              CustomAppBar(
                  quoteIndex: qIndex,
                  onTap: () {
                    getRandomQuote();
                  }),
              const SizedBox(height: 5),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  child:
                                      const Icon(Icons.flight_takeoff_outlined),
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _locationPermissionGranted == false
                                        ? const Text(
                                            "Turn on location services.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        : const Text("Location enabled"),
                                    const SizedBox(height: 5),
                                    _currentCity.isEmpty
                                        ? const Text(
                                            "please enable locations for a better \nexperiences.",
                                            maxLines: 2,
                                            style: TextStyle(),
                                          )
                                        : Text("Current City $_currentCity"),
                                    const SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: _locationPermissionGranted == true
                                          ? const SizedBox()
                                          : MaterialButton(
                                              onPressed: () async {
                                                checkLocationPermission();
                                              },
                                              color: Colors.grey.shade100,
                                              shape: const StadiumBorder(),
                                              child: const Text(
                                                "Enable location",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Incase of emergency dial me",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Emergency(),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Explore your power",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const CustomCarousel(),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Explore LiveSafe",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const LiveSafe(),
                    const SafeHome(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
