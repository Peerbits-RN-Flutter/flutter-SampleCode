/*
import 'package:location/location.dart';

class LocationUtils {
  LocationUtils();

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  Future<bool> _hasLocationPermission() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.granted) {
      return true;
    } else {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return false;
  }

  Future<bool> _isServiceEnabled() async {
    if (await _hasLocationPermission()) {
      _serviceEnabled = await location.serviceEnabled();
      if (_serviceEnabled) {
        return true;
      } else {
        _serviceEnabled = await location.requestService();
      }
    }
    return false;
  }

  Future<LocationData> getCurrentLocation() async {
    location.changeSettings(accuracy: LocationAccuracy.high);
    bool _isService = await _isServiceEnabled();
    if (_isService) {
      return location.getLocation();
    }
    return null;
  }
}
*/
