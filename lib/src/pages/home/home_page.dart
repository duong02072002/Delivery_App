import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/home/home_controller.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomeController con = Get.put(HomeController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => con.signOut(),
          child: const Text(
            'Sign off',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
