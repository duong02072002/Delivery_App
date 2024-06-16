import 'package:flutter_delivery_app/src/providers/orders_provider.dart';
import 'package:get/get.dart';

class RestaurantStatisticsCreateController extends GetxController {
  final OrdersProvider _ordersProvider = OrdersProvider();

  RxMap<String, dynamic> totalSales = RxMap<String, dynamic>();
  RxBool isLoading = false.obs;

  Future<void> fetchTotalSales() async {
    isLoading.value = true;
    try {
      Map<String, dynamic> sales = await _ordersProvider.getTotalSales();
      totalSales.assignAll(sales); // Assign fetched data to totalSales
    } catch (e) {
      // Handle error, if any
      print('Failed to fetch total sales: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
