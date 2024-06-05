import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:flutter_delivery_app/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/categories/create/restaurant_categories_create_page.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/categories/list/restaurant_categories_list_page.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/drivers/create/restaurant_drivers_create_page.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/drivers/list/restaurant_drivers_list_page.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/home/restaurant_home_controller.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/products/list/restaurant_products_list_page.dart';
import 'package:flutter_delivery_app/src/utils/custom_animated_bottom_bar.dart';
import 'package:get/get.dart';

class RestaurantHomePage extends StatelessWidget {
  RestaurantHomeController con = Get.put(RestaurantHomeController());

  RestaurantHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: Obx(
        () => IndexedStack(
          index: con.indexTab.value,
          children: [
            RestaurantOrdersListPage(),
            // RestaurantCategoriesCreatePage(),
            RestaurantCategoriesListPage(),
            // RestaurantProductsCreatePage(),
            RestaurantProductsListPage(),
            // RestaurantDriversCreatePage(),
            RestaurantDriversListPage(),
            ClientProfileInfoPage(),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Obx(() => CustomAnimatedBottomBar(
          containerHeight: 58,
          backgroundColor: Colors.amber, // Thay đổi màu sắc của bottom bar
          showElevation: true,
          itemCornerRadius: 30, // Thay đổi hình dạng của bottom bar
          curve: Curves.easeIn,
          selectedIndex: con.indexTab.value,
          onItemSelected: (index) => con.changeTab(index),
          items: [
            BottomNavyBarItem(
                icon: const Icon(Icons.list),
                title: const Text(
                  'Orders',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ), // Thay đổi kích thước và kiểu chữ
                activeColor: Colors.white,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: const Icon(Icons.category),
                title: const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ), // Thay đổi kích thước và kiểu chữ
                activeColor: Colors.white,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: const Icon(Icons.restaurant),
                title: const Text(
                  'Product',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ), // Thay đổi kích thước và kiểu chữ
                activeColor: Colors.white,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: const Icon(Icons.person_add_alt_1_outlined),
                title: const Text(
                  'Driver',
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
