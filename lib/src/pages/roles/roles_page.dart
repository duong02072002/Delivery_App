import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/models/rol.dart';
import 'package:flutter_delivery_app/src/pages/roles/roles_controller.dart';
import 'package:get/get.dart';

class RolesPage extends StatelessWidget {
  RolesController con = Get.put(RolesController());

  RolesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35),
        child: AppBar(
          title: const Text(
            'Select The Role',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
            ),
          ),
          backgroundColor:
              Colors.amber.shade400, // Đổi màu nền của AppBar thành màu vàng
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.12),
        child: ListView(
          children: con.user.roles != null
              ? con.user.roles!.map((Rol rol) {
                  return _cardRol(rol);
                }).toList()
              : [],
        ),
      ),
    );
  }

  Widget _cardRol(Rol rol) {
    return GestureDetector(
      onTap: () => con.goToPageRol(rol),
      child: Column(
        children: [
          Container(
            // IMAGE
            margin: const EdgeInsets.only(bottom: 15, top: 15),
            height: 100,
            child: FadeInImage(
              image: NetworkImage(rol.image!),
              fit: BoxFit.contain,
              fadeInDuration: const Duration(milliseconds: 50),
              placeholder: const AssetImage('assets/img/no-image.png'),
            ),
          ),
          Text(
            rol.name ?? '',
            style: const TextStyle(fontSize: 16, color: Colors.black),
          )
        ],
      ),
    );
  }
}
