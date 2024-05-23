import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../models/order.dart';
import '../../../../models/response_api.dart';
import '../../../../models/user.dart';
import '../../../../providers/orders_provider.dart';
import '../../../../providers/users_provider.dart';

class RestaurantOrdersDetailController extends GetxController {
  Order order = Order.fromJson(Get.arguments['order']);

  var total = 0.0.obs;
  var idDelivery = ''.obs;

  UsersProvider usersProvider = UsersProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  List<User> users = <User>[].obs;

  RestaurantOrdersDetailController() {
    print('Order: ${order.toJson()}');
    getDeliveryMen();
    getTotal();
  }

  void updateOrder() async {
    if (idDelivery.value != '') {
      // NẾU TÔI CHỌN GIAO HÀNG
      order.idDelivery = idDelivery.value;
      ResponseApi responseApi = await ordersProvider.updateToDispatched(order);
      Fluttertoast.showToast(
          msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
      if (responseApi.success == true) {
        Get.offNamedUntil('/restaurant/home', (route) => false);
      }
    } else {
      Get.snackbar('Request Denied', 'You Must Assign The Delivery Person');
    }
  }

  void getDeliveryMen() async {
    var result = await usersProvider.findDeliveryMen();
    users.clear();
    users.addAll(result);
  }

  void getTotal() {
    total.value = 0.0;
    for (var product in order.products!) {
      total.value = total.value + (product.quantity! * product.price!);
    }
  }
}
