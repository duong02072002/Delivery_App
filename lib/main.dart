import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/models/user.dart';
import 'package:flutter_delivery_app/src/pages/client/address/create/client_address_create_page.dart';
import 'package:flutter_delivery_app/src/pages/client/address/list/client_address_list_page.dart';
import 'package:flutter_delivery_app/src/pages/client/home/client_home_page.dart';
import 'package:flutter_delivery_app/src/pages/client/orders/create/client_orders_create_page.dart';
import 'package:flutter_delivery_app/src/pages/client/orders/detail/client_orders_detail_page.dart';
import 'package:flutter_delivery_app/src/pages/client/orders/map/client_orders_map_page.dart';
import 'package:flutter_delivery_app/src/pages/client/products/list/client_products_list_page.dart';
import 'package:flutter_delivery_app/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:flutter_delivery_app/src/pages/client/profile/update/client_profile_update_page.dart';
import 'package:flutter_delivery_app/src/pages/delivery/home/delivery_home_page.dart';
import 'package:flutter_delivery_app/src/pages/delivery/orders/map/delivery_orders_map_page.dart';
import 'package:flutter_delivery_app/src/pages/delivery/orders/detail/delivery_orders_detail_page.dart';
import 'package:flutter_delivery_app/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:flutter_delivery_app/src/pages/home/home_page.dart';
import 'package:flutter_delivery_app/src/pages/login/login_page.dart';
import 'package:flutter_delivery_app/src/pages/register/register_page.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/categories/create/restaurant_categories_create_page.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/drivers/create/restaurant_drivers_create_page.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/home/restaurant_home_page.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/orders/detail/restaurant_orders_detail_page.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/products/list/restaurant_products_list_page.dart';
import 'package:flutter_delivery_app/src/pages/roles/roles_page.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'src/pages/client/payments/create/client_payments_create_page.dart';

User userSession = User.fromJson(GetStorage().read('user') ?? {});
// PushNotificationsProvider pushNotificationsProvider =
//     PushNotificationsProvider();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
//   print('Receiving notification in the background ${message.messageId}');
//   // pushNotificationsProvider.showNotification(message);
// }

// void main() async {
//   await GetStorage.init();
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: FirebaseConfig.currentPlatform,
//   );
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   pushNotificationsProvider.initPushNotifications();
//   runApp(const MyApp());
// }

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51PL3MAHh3zSP7bhawCnn9W77Xyp20ns3Q2XUG8SobIXjgzP15LqTAoh6N530jC6Byd49gZYkyUDdPbxJ5Vr2Ci7000wiPjwXvC';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('The User session Token: ${userSession.sessionToken}');
    //pushNotificationsProvider.onMessageListener();
  }

  @override
  Widget build(BuildContext context) {
    print('User Id: ${userSession.id}');

    return GetMaterialApp(
      title: 'Delivery APP',
      debugShowCheckedModeBanner: false,
      initialRoute: userSession.id != null
          ? userSession.roles!.length > 1
              ? '/roles'
              : '/client/home'
          : '/',
      getPages: [
        GetPage(name: '/', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/roles', page: () => RolesPage()),
        GetPage(name: '/restaurant/home', page: () => RestaurantHomePage()),
        GetPage(
            name: '/restaurant/drivers/create',
            page: () => RestaurantDriversCreatePage()),
        GetPage(
            name: '/restaurant/products/list',
            page: () => RestaurantProductsListPage()),
        GetPage(
            name: '/restaurant/products/create',
            page: () => RestaurantProductsCreatePage()),
        GetPage(
            name: '/restaurant/categories/create',
            page: () => RestaurantCategoriesCreatePage()),
        GetPage(
            name: '/restaurant/orders/list',
            page: () => RestaurantOrdersListPage()),
        GetPage(
            name: '/restaurant/orders/detail',
            page: () => RestaurantOrdersDetailPage()),
        GetPage(
            name: '/delivery/orders/list',
            page: () => DeliveryOrdersListPage()),
        GetPage(name: '/client/home', page: () => ClientHomePage()),
        GetPage(
            name: '/delivery/orders/detail',
            page: () => DeliveryOrdersDetailPage()),
        GetPage(
            name: '/delivery/orders/map', page: () => DeliveryOrdersMapPage()),
        GetPage(name: '/delivery/home', page: () => DeliveryHomePage()),
        GetPage(
            name: '/client/products/list',
            page: () => ClientProductsListPage()),
        GetPage(
            name: '/client/profile/info', page: () => ClientProfileInfoPage()),
        GetPage(
            name: '/client/profile/update',
            page: () => ClientProfileUpdatePage()),
        GetPage(
            name: '/client/orders/create',
            page: () => ClientOrdersCreatePage()),
        GetPage(
            name: '/client/orders/detail',
            page: () => ClientOrdersDetailPage()),
        GetPage(name: '/client/orders/map', page: () => ClientOrdersMapPage()),
        GetPage(
            name: '/client/address/create',
            page: () => ClientAddressCreatePage()),
        GetPage(
            name: '/client/address/list', page: () => ClientAddressListPage()),
        GetPage(
            name: '/client/payments/create',
            page: () => const ClientPaymentsCreatePage()),
      ],
      theme: ThemeData(
        primaryColor: Colors.amber,
        colorScheme: ColorScheme(
          primary: Colors.amber.shade500,
          secondary: Colors.amberAccent,
          brightness: Brightness.light,
          onBackground: Colors.grey,
          onPrimary: Colors.grey,
          surface: Colors.grey,
          onSurface: Colors.amber, // Sử dụng màu này cho onSurface
          error: Colors.grey,
          onError: Colors.grey,
          onSecondary: Colors.grey,
          background: Colors.white,
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              // Đảm bảo màu văn bản không thay đổi khi được chọn
              titleMedium: const TextStyle(color: Colors.black87),
            ),
      ),
      navigatorKey: Get.key,
    );
  }
}
