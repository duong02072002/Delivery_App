import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/client/address/map/client_address_map_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientAddressMapPage extends StatelessWidget {
  final ClientAddressMapController con = Get.put(ClientAddressMapController());

  ClientAddressMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(42),
        child: AppBar(
          backgroundColor: Colors.amber,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            'Locate Your Address',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          _googleMaps(),
          _iconMyLocation(),
          _cardAddress(),
          _buttonAccept(context),
        ],
      ),
    );
  }

  Widget _buttonAccept(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 55,
      child: ElevatedButton(
        onPressed: () => con.selectRefPoint(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SELECT THIS POINT',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontFamily: 'NimbusSans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardAddress() {
    return Container(
      width: double.infinity,
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.symmetric(vertical: 50),
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Obx(
            () => Text(
              con.addressName.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconMyLocation() {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Center(
        child: Image.asset(
          'assets/img/my_location_yellow.png',
          width: 65,
          height: 65,
        ),
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      initialCameraPosition: con.initialPosition,
      mapType: MapType.normal,
      myLocationButtonEnabled: true, // Cho phép hiển thị nút "My Location"
      myLocationEnabled: true, // Cho phép hiển thị điểm vị trí hiện tại
      zoomControlsEnabled: true, // Tắt nút điều chỉnh zoom mặc định
      onMapCreated: con.onMapCreate,
      onCameraMove: (CameraPosition position) {
        con.initialPosition = position;
      },
      onCameraIdle: () async {
        await con.setLocationDraggableInfo();
      },
    );
  }
}
