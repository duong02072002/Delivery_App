import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/client/address/map/client_address_map_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientAddressMapPage extends StatelessWidget {
  ClientAddressMapController con = Get.put(ClientAddressMapController());

  ClientAddressMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Locate Your Address On The Map',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Stack(
            children: [
              _googleMaps(),
              _iconMyLocation(),
              _cardAddress(),
              _buttonAccept(context)
            ],
          ),
        ));
  }

  Widget _buttonAccept(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 30),
      child: ElevatedButton(
        onPressed: () => con.selectRefPoint(context),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(15)),
        child: const Text(
          'SELECT THIS POINT',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _cardAddress() {
    return Container(
      width: double.infinity,
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            con.addressName.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
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
      onMapCreated: con.onMapCreate,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onCameraMove: (position) {
        con.initialPosition = position;
      },
      onCameraIdle: () async {
        await con
            .setLocationDraggableInfo(); // BẮT ĐẦU ĐẠT VỊ TRÍ TRUNG TÂM BẢN ĐỒ
      },
    );
  }
}
