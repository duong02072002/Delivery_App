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
import '../../../../providers/orders_provider.dart';

class ClientOrdersMapController extends GetxController {
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

  ClientOrdersMapController() {
    print('Order: ${order.toJson()}');

    checkGPS(); // KIỂM TRA GPS CÓ HOẠT ĐỘNG KHÔNG
    connectAndListen();
  }

  void connectAndListen() {
    socket.connect();
    socket.onConnect((_) {
      print('Connected to socket.io server');
      listenPosition();
      listenToDelivered();
    });
    socket.onConnectError((error) {
      print('Socket connect error: $error');
    });
    socket.onDisconnect((_) {
      print('Disconnected from socket.io server');
    });
  }

  void listenPosition() {
    socket.on('position/${order.id}', (data) {
      print('Received position data: $data');
      if (data != null && data['lat'] != null && data['lng'] != null) {
        addMarker(
          'delivery',
          data['lat'],
          data['lng'],
          'Place of delivery',
          '',
          deliveryMarker!,
        );
      } else {
        print('Received invalid position data');
      }
    });
  }

  void listenToDelivered() {
    socket.on('delivered/${order.id}', (data) {
      Fluttertoast.showToast(
          msg: 'The order status was updated to delivered',
          toastLength: Toast.LENGTH_LONG);
      Get.offNamedUntil('/client/home', (route) => false);
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
    print('Location service enabled: $isLocationEnabled');
    if (isLocationEnabled) {
      updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();
      print('Location GPS enabled: $locationGPS');
      if (locationGPS) {
        updateLocation();
      } else {
        print('Location services are disabled and could not be enabled');
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

  void updateLocation() async {
    try {
      await _determinePosition();

      position = await Geolocator.getLastKnownPosition();
      print('Current position: $position');
      if (position != null) {
        animateCameraPosition(
            order.lat ?? position!.latitude, order.lng ?? position!.longitude);

        addMarker(
          'delivery',
          order.lat ?? position!.latitude,
          order.lng ?? position!.longitude,
          'Your delivery man',
          '',
          deliveryMarker!,
        );

        addMarker(
          'home',
          order.address?.lat ?? 10.8231,
          order.address?.lng ?? 106.6297,
          'Place of delivery',
          '',
          homeMarker!,
        );

        LatLng from = LatLng(
            order.lat ?? position!.latitude, order.lng ?? position!.longitude);
        LatLng to = LatLng(
            order.address?.lat ?? 10.8231, order.address?.lng ?? 106.6297);

        setPolylines(from, to);
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  void callNumber() async {
    String number = order.delivery?.phone ?? ''; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  void centerPosition() {
    if (position != null) {
      animateCameraPosition(position!.latitude, position!.longitude);
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

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Error determining position: $e');
      return Future.error('Error determining position: $e');
    }
  }

  void onMapCreate(GoogleMapController controller) {
    // controller.setMapStyle(
    //     '[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
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
