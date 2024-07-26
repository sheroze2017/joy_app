import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationController extends GetxController {
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  var location = 'Select Location'.obs;

  RxDouble get latitude => _latitude;
  RxDouble get longitude => _longitude;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    final prefs = await SharedPreferences.getInstance();
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanation as to why it
        // needs this permission/purpose before requesting it.)
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _latitude.value = position.latitude;
    _longitude.value = position.longitude;

    prefs.setDouble('latitude', _latitude.value);
    prefs.setDouble('longitude', _longitude.value);

    update();
  }

  Future<void> setLocation(lat, lng, loca) async {
    _latitude.value = lat;
    _longitude.value = lng;
    location.value = loca;
  }
}
