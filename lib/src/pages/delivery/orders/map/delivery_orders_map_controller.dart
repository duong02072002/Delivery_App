import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:socket_io_client/socket_io_client.dart';
import '../../../../environment/environment.dart';
import '../../../../models/order.dart';
import '../../../../models/response_api.dart';
import '../../../../providers/orders_provider.dart';

class DeliveryOrdersMapController extends GetxController {
  Socket socket = io('${Environment.API_URL}orders/delivery', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });

  Order order = Order.fromJson(Get.arguments['order'] ?? {});
  OrdersProvider ordersProvider = OrdersProvider();

  CameraPosition initialPosition =
      const CameraPosition(target: LatLng(10.8231, 106.6297), zoom: 14.4746);

  LatLng? addressLatLng;
  var addressName = ''.obs;

  Completer<GoogleMapController> mapController = Completer();
  Position? position;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? homeMarker;

  StreamSubscription? positionSubscribe;

  Set<Polyline> polylines = <Polyline>{}.obs;
  List<LatLng> points = [];

  double distanceBetween = 0.0;
  bool isClose = false;

  DeliveryOrdersMapController() {
    print('Order: ${order.toJson()}');

    checkGPS(); //KIỂM TRA GPS CÓ HOẠT ĐỘNG KHÔNG
    connectAndListen();
  }

  void isCloseToDeliveryPosition() {
    if (position != null) {
      distanceBetween = Geolocator.distanceBetween(position!.latitude,
          position!.longitude, order.address!.lat!, order.address!.lng!);

      print('distanceBetween $distanceBetween');

      if (distanceBetween <= 20 && isClose == false) {
        isClose = true;
        update();
      }
    }
  }

  void connectAndListen() {
    socket.connect();
    socket.onConnect((data) {
      print('THIS DEVICE CONNECTED TO SOCKET IO');
    });
  }

  void emitPosition() {
    if (position != null) {
      socket.emit('position', {
        'id_order': order.id,
        'lat': position!.latitude,
        'lng': position!.longitude,
      });
    }
  }

  void emitToDelivered() {
    socket.emit('delivered', {
      'id_order': order.id,
    });
  }

  Future setLocationDraggableInfo() async {
    double lat = initialPosition.target.latitude;
    double lng = initialPosition.target.longitude;

    List<Placemark> address = await placemarkFromCoordinates(lat, lng);

    if (address.isNotEmpty) {
      String direction = address[0].thoroughfare ?? '';
      String street = address[0].subThoroughfare ?? '';
      String city = address[0].locality ?? '';
      String department = address[0].administrativeArea ?? '';
      String country = address[0].country ?? '';
      addressName.value = '$direction #$street, $city, $department';
      addressLatLng = LatLng(lat, lng);
      print(
          'LAT Y LNG: ${addressLatLng?.latitude ?? 0} ${addressLatLng?.longitude ?? 0}');
    }
  }

  Future<BitmapDescriptor> createMarkerFromAssets(String path) async {
    ImageConfiguration configuration = const ImageConfiguration();
    BitmapDescriptor descriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);

    return descriptor;
  }

  void addMarker(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content));

    markers[id] = marker;

    update();
  }

  void checkGPS() async {
    deliveryMarker =
        await createMarkerFromAssets('assets/img/delivery_little.png');
    homeMarker =
        await createMarkerFromAssets('assets/img/my_location_yellow.png');

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

  Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS, pointFrom, pointTo);

    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
        polylineId: const PolylineId('poly'),
        color: Colors.amber,
        points: points,
        width: 5);

    polylines.add(polyline);
    update();
  }

  void updateToDelivered() async {
    if (distanceBetween <= 20) {
      ResponseApi responseApi = await ordersProvider.updateToDelivered(order);
      Fluttertoast.showToast(
          msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
      if (responseApi.success == true) {
        emitToDelivered();
        Get.offNamedUntil('/delivery/home', (route) => false);
      }
    } else {
      Get.snackbar('Operation not permitted',
          'You must be closer to the order delivery position');
    }
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      position = await Geolocator.getLastKnownPosition(); // LAT Y LNG (ACTUAL)
      saveLocation();
      animateCameraPosition(
          position?.latitude ?? 10.8231, position?.longitude ?? 106.6297);

      addMarker(
          'delivery',
          position?.latitude ?? 10.8231,
          position?.longitude ?? 106.6297,
          'Your position',
          '',
          deliveryMarker!);

      addMarker('home', order.address?.lat ?? 10.8231,
          order.address?.lng ?? 106.6297, 'Place of delivery', '', homeMarker!);

      LatLng from = LatLng(position!.latitude, position!.longitude);
      LatLng to =
          LatLng(order.address?.lat ?? 10.8231, order.address?.lng ?? 106.6297);

      setPolylines(from, to);

      LocationSettings locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.best, distanceFilter: 1);

      positionSubscribe =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position pos) {
        // VỊ TRÍ TRONG THỜI GIAN THỰC
        position = pos;
        addMarker(
            'delivery',
            position?.latitude ?? 10.8231,
            position?.longitude ?? 106.6297,
            'Your position',
            '',
            deliveryMarker!);
        animateCameraPosition(
            position?.latitude ?? 10.8231, position?.longitude ?? 106.6297);
        emitPosition();
        isCloseToDeliveryPosition();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void callNumber() async {
    String number = order.client?.phone ?? ''; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  void centerPosition() {
    if (position != null) {
      animateCameraPosition(position!.latitude, position!.longitude);
    }
  }

  void saveLocation() async {
    if (position != null) {
      order.lat = position!.latitude;
      order.lng = position!.longitude;
      await ordersProvider.updateLatLng(order);
    }
  }

  Future animateCameraPosition(double lat, double lng) async {
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 16, bearing: 0)));
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

  void onMapCreate(GoogleMapController controller) {
    mapController.complete(controller);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    socket.disconnect();
    positionSubscribe?.cancel();
  }
}
