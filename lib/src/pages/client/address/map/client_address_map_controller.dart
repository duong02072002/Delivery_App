import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;

class ClientAddressMapController extends GetxController {
  CameraPosition initialPosition =
      const CameraPosition(target: LatLng(10.8231, 106.6297), zoom: 14.4746);

  LatLng? addressLatLng;
  var addressName = ''.obs;

  Completer<GoogleMapController> mapController = Completer();
  Position? position;

  @override
  void onInit() {
    super.onInit();
    checkGPS(); // KIỂM TRA GPS CÓ HOẠT ĐỘNG KHÔNG
  }

  Future<void> setLocationDraggableInfo() async {
    double lat = initialPosition.target.latitude;
    double lng = initialPosition.target.longitude;

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];

      String thoroughfare = placemark.thoroughfare ?? '';
      String subThoroughfare = placemark.subThoroughfare ?? '';
      String locality = placemark.locality ?? '';
      String subLocality = placemark.subLocality ?? '';
      String administrativeArea = placemark.administrativeArea ?? '';
      String country = placemark.country ?? '';

      // Extract district (quận) if available
      String district = placemark.subAdministrativeArea ?? '';

      // Build the complete address string
      String address = '${thoroughfare.isNotEmpty ? '$thoroughfare, ' : ''}'
          '${subThoroughfare.isNotEmpty ? '#$subThoroughfare, ' : ''}'
          '${district.isNotEmpty ? '$district, ' : ''}'
          '${subLocality.isNotEmpty ? '$subLocality, ' : ''}'
          '$locality, $administrativeArea';

      // Update observable variable
      addressName.value = address;
      addressLatLng = LatLng(lat, lng);

      print(
          'LAT AND LNG: ${addressLatLng?.latitude ?? 0} ${addressLatLng?.longitude ?? 0}');
    }
  }

  void selectRefPoint(BuildContext context) {
    if (addressLatLng != null) {
      Map<String, dynamic> data = {
        'address': addressName.value,
        'lat': addressLatLng!.latitude,
        'lng': addressLatLng!.longitude,
      };
      Navigator.pop(context, data);
    }
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationEnabled == true) {
      updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS == true) {
        updateLocation();
      }
    }
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      position =
          await Geolocator.getLastKnownPosition(); // LAT AND LNG (ACTUAL)
      animateCameraPosition(
          position?.latitude ?? 10.8231, position?.longitude ?? 106.6297);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future animateCameraPosition(double lat, double lng) async {
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 25, bearing: 0)));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void onMapCreate(GoogleMapController controller) async {
    mapController.complete(controller);
    await _setMapStyle(controller);
  }

  Future<void> _setMapStyle(GoogleMapController controller) async {
    try {
      String mapStyle = await DefaultAssetBundle.of(Get.context!)
          .loadString('assets/map_style.json');
      controller.setMapStyle(mapStyle);
    } catch (e) {
      print("Failed to set map style: $e");
    }
  }

  void animateCameraToCurrentLocation() {
    if (position != null) {
      animateCameraPosition(position!.latitude, position!.longitude);
    }
  }
}
