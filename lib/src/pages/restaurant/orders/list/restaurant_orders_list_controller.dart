import 'package:get/get.dart';

import '../../../../models/order.dart';
import '../../../../providers/orders_provider.dart';

class RestaurantOrdersListController extends GetxController {
  OrdersProvider ordersProvider = OrdersProvider();
  List<String> status =
      <String>['PAID', 'DISPATCHED', 'ON THE WAY', 'DELIVERED'].obs;

  Future<List<Order>> getOrders(String status) async {
    return await ordersProvider.findByStatus(status);
  }

  // void goToOrderDetail(Order order) {
  //   Get.toNamed('/restaurant/orders/detail',
  //       arguments: {'order': order.toJson()});
  // }
  void goToOrderDetail(Order order) async {
    await Get.toNamed('/restaurant/orders/detail',
        arguments: {'order': order.toJson()});
  }
}
