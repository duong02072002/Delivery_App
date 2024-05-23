import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/client/orders/list/client_orders_list_controller.dart';
import 'package:flutter_delivery_app/src/pages/delivery/orders/list/delivery_orders_list_controller.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import 'package:get/get.dart';

import '../../../../models/order.dart';
import '../../../../utils/relative_time_util.dart';
import '../../../../widgets/no_data_widget.dart';

class ClientOrdersListPage extends StatelessWidget {
  final ClientOrdersListController con = Get.put(ClientOrdersListController());

  ClientOrdersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
          length: con.status.length,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: AppBar(
                backgroundColor: Colors.amber,
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  labelColor: Colors.black,
                  unselectedLabelColor:
                      const Color.fromARGB(255, 244, 240, 240),
                  tabs: con.status.map((status) {
                    return Tab(
                      child: Text(
                        status,
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'NimbusSans',
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            body: TabBarView(
              children: con.status.map((status) {
                return FutureBuilder<List<Order>>(
                  future: con.getOrders(status),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        padding:
                            const EdgeInsets.only(top: 12, left: 18, right: 18),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return _cardOrder(snapshot.data![index]);
                        },
                      );
                    } else {
                      return Center(
                        child: NoDataWidget(text: 'No Orders Available'),
                      );
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ));
  }

  Widget _cardOrder(Order order) {
    return GestureDetector(
      onTap: () => con.goToOrderDetail(order),
      child: SizedBox(
        height: 150,
        //margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Card(
          color: Colors.white,
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Order #${order.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Order: ${RelativeTimeUtil.getRelativeTime(order.timestamp ?? 0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Delivery Man: ${order.delivery?.name ?? 'Not Assigned'} ${order.delivery?.lastname ?? ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Delivery: ${order.address?.address ?? ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
