import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../models/order.dart';
import '../../../../models/response_api.dart';
import '../../../../models/user.dart';
import '../../../../providers/orders_provider.dart';
import '../../../../providers/users_provider.dart';

class ClientOrdersDetailController extends GetxController {
  Order order = Order.fromJson(Get.arguments['order']);

  var total = 0.0.obs;
  var idDelivery = ''.obs;

  UsersProvider usersProvider = UsersProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  List<User> users = <User>[].obs;

  ClientOrdersDetailController() {
    print('Order: ${order.toJson()}');
    getTotal();
  }

  void goToOrderMap() {
    Get.toNamed('/client/orders/map', arguments: {'order': order.toJson()});
  }

  void getTotal() {
    total.value = 0.0;
    for (var product in order.products!) {
      total.value = total.value + (product.quantity! * product.price!);
    }
  }
}
