import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/client/home/client_home_controller.dart';
import 'package:flutter_delivery_app/src/pages/client/orders/create/client_orders_create_page.dart';
import 'package:flutter_delivery_app/src/pages/client/orders/list/client_orders_list_page.dart';
import 'package:flutter_delivery_app/src/pages/client/products/list/client_products_list_page.dart';
import 'package:flutter_delivery_app/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:flutter_delivery_app/src/utils/custom_animated_bottom_bar.dart';
import 'package:get/get.dart';

class ClientHomePage extends StatelessWidget {
  ClientHomeController con = Get.put(ClientHomeController());

  ClientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: Obx(
        () => IndexedStack(
          index: con.indexTab.value,
          children: [
            ClientProductsListPage(),
            ClientOrdersCreatePage(),
            ClientOrdersListPage(),
            ClientProfileInfoPage(),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Obx(() => CustomAnimatedBottomBar(
          containerHeight: 58,
          backgroundColor: Colors.amber[400], // Thay đổi màu sắc của bottom bar
          showElevation: true,
          itemCornerRadius: 30, // Thay đổi hình dạng của bottom bar
          curve: Curves.easeIn,
          selectedIndex: con.indexTab.value,
          onItemSelected: (index) => con.changeTab(index),
          items: [
            BottomNavyBarItem(
                icon: const Icon(Icons.apps),
                title: const Text(
                  'Product',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ), // Thay đổi kích thước và kiểu chữ
                activeColor: Colors.white,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: const Icon(Icons.shopping_bag_outlined),
                title: const Text(
                  'My Bag',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ), // Thay đổi kích thước và kiểu chữ
                activeColor: Colors.white,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: const Icon(Icons.list),
                title: const Text(
                  'My Orders',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ), // Thay đổi kích thước và kiểu chữ
                activeColor: Colors.white,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: const Icon(Icons.person),
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ), // Thay đổi kích thước và kiểu chữ
                activeColor: Colors.white,
                inactiveColor: Colors.black),
          ],
        ));
  }
}
