import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/statistics/create/restaurant_statistics_create_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RestaurantStatisticsCreatePage extends StatelessWidget {
  final RestaurantStatisticsCreateController controller =
      Get.put(RestaurantStatisticsCreateController());

  RestaurantStatisticsCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      symbol: '\$', // Ký hiệu tiền tệ là $
      decimalDigits: 2, // Số lượng chữ số thập phân
      locale: 'en_US', // Ngôn ngữ
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sales Statistics',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'NimbusSans',
          ),
        ),
        backgroundColor: Colors.amber,
        leading: _buttonBack(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            // padding: const EdgeInsets.all(50.0),
            padding: const EdgeInsets.only(top: 120),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () {
                      if (controller.isLoading.value) {
                        return const CircularProgressIndicator();
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 24),
                            StatisticCard(
                              title: 'Products Sold',
                              value:
                                  '${controller.totalSales['totalQuantitySold']} ',
                              backgroundColor: Colors.grey,
                              titleStyle: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'NimbusSans',
                              ),
                              valueStyle: const TextStyle(
                                fontSize: 26,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 24),
                            StatisticCard(
                              title: 'Total Sales Amount',
                              value: controller
                                          .totalSales['totalSalesAmount'] !=
                                      null
                                  ? formatter.format(
                                      controller.totalSales['totalSalesAmount'])
                                  : 'N/A',
                              backgroundColor: Colors.grey,
                              titleStyle: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'NimbusSans',
                              ),
                              valueStyle: const TextStyle(
                                fontSize: 26,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.fetchTotalSales();
        },
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buttonBack() {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      child: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 35,
        ),
      ),
    );
  }
}

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final Color backgroundColor;
  final TextStyle titleStyle;
  final TextStyle valueStyle;

  const StatisticCard({
    super.key,
    required this.title,
    required this.value,
    this.backgroundColor = Colors.white,
    this.titleStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    this.valueStyle = const TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: titleStyle,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: valueStyle,
            ),
          ],
        ),
      ),
    );
  }
}
