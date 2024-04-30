import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import 'package:get/get.dart';

class RestaurantOrdersListPage extends StatelessWidget {
  RestaurantOrdersListController con =
      Get.put(RestaurantOrdersListController());

  RestaurantOrdersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Restaurant Orders List'),
      ),
    );
  }
}
