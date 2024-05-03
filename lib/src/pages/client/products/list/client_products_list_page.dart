import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:get/get.dart';

class ClientProductsListPage extends StatelessWidget {
  ClientProductsListController con = Get.put(ClientProductsListController());

  ClientProductsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('Client product list'),
    ));
  }
}
