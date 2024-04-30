import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/models/user.dart';
import 'package:flutter_delivery_app/src/pages/home/home_page.dart';
import 'package:flutter_delivery_app/src/pages/login/login_page.dart';
import 'package:flutter_delivery_app/src/pages/register/register_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

User userSession = User.fromJson(GetStorage().read('user') ?? {});

void main() async {
  await GetStorage.init();
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
  }

  @override
  Widget build(BuildContext context) {
    print('User Id: ${userSession.id}');

    return GetMaterialApp(
      title: 'Delivery APP',
      debugShowCheckedModeBanner: false,
      initialRoute: userSession.id != null ? '/home' : '/',
      getPages: [
        GetPage(name: '/', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/home', page: () => HomePage()),
      ],
      theme: ThemeData(
        primaryColor: Colors.amber,
        colorScheme: const ColorScheme(
          primary: Colors.amber,
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
