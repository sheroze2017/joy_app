import 'dart:convert';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/map/model/place_model.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:joy_app/widgets/rounded_button.dart';
import 'package:joy_app/widgets/single_select_dropdown.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final TextEditingController _searchController = TextEditingController();
  Position? _currentLocation;
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Error', 'Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
          'Location Error', 'Location permissions are permanently denied.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        Get.snackbar('Location Error', 'Location permissions are denied.');
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        _currentLocation = position;
      });

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      _updateMarkers(position.latitude, position.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address = placemark.name ?? '';
        setState(() {
          _currentAddress = address;
        });
      }
    } catch (e) {
      Get.snackbar('Location Error', 'Failed to get location: $e');
    } finally {
      setState(() {});
    }
  }

  void _updateMarkers(double lat, double lng) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(lat, lng),
          draggable: true,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: _currentAddress ?? 'Current Location',
          ),
        ),
      );
    });
  }

  Future<List<String>> _handleSearch(String query) async {
    final url =
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1';
    final response = await http.get(Uri.parse(url));
    final jsonData = jsonDecode(response.body);
    return jsonData.map((element) => element['display_name']).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _currentLocation?.latitude ?? 45.521563,
                _currentLocation?.longitude ?? -122.677433,
              ),
              zoom: 14.0,
            ),
            onLongPress: (argument) async {
              _updateMarkers(argument.latitude, argument.longitude);
              List<Placemark> placemarks = await placemarkFromCoordinates(
                argument.latitude,
                argument.longitude,
              );
            },
            markers: _markers,
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: CustomDropdown<String>.searchRequest(
              hintText: 'Select location',
              onChanged: (value) {
                print(value);
              },
              futureRequest: _handleSearch,
            ),
          ),
        ],
      ),
    );
  }
}
  // Positioned(
  //             top: 20,
  //             left: 20,
  //             right: 20,
  //             child: RoundedButtonSmall(
  //               backgroundColor: Colors.black,
  //               textColor: Colors.white,
  //               text: 'press',
  //               onPressed: () {
  //                 _handleSearch('Naya nazimabad');
  //               },
  //             )),
  //         Positioned(
  //             top: 50,
  //             left: 20,
  //             right: 20,
  //             child: CustomDropdown<String>.searchRequest(
  //               hintText: 'Select job role',
  //               onChanged: (value) {
  //                 print(value);
  //               },
  //               futureRequest: _handleSearch,
  //             )),
       
