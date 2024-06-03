import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/delivery/orders/detail/delivery_orders_detail_controller.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:get/get.dart';

import '../../../../models/product.dart';
import '../../../../models/user.dart';
import '../../../../utils/relative_time_util.dart';
import '../../../../widgets/no_data_widget.dart';

class DeliveryOrdersDetailPage extends StatelessWidget {
  DeliveryOrdersDetailController con =
      Get.put(DeliveryOrdersDetailController());

  DeliveryOrdersDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          bottomNavigationBar: Container(
            color: const Color.fromRGBO(245, 245, 245, 1),
            // height: MediaQuery.of(context).size.height * 0.38,
            height: con.order.status == 'DELIVERED'
                ? MediaQuery.of(context).size.height * 0.35
                : MediaQuery.of(context).size.height * 0.38,
            //padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                _dataDate(),
                _dataClient(),
                _dataAddress(),
                _totalToPay(context),
              ],
            ),
          ),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              backgroundColor: Colors.amber,
              iconTheme: const IconThemeData(color: Colors.black),
              title: Text(
                'Order #${con.order.id}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          body: con.order.products!.isNotEmpty
              ? ListView(
                  children: con.order.products!.map((Product product) {
                    return _cardProduct(product);
                  }).toList(),
                )
              : Center(
                  child: NoDataWidget(
                  text: 'Without Product',
                )),
        ));
  }

  Widget _dataClient() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: const Text(
          'Client And Telephone',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${con.order.client?.name ?? ''} ${con.order.client?.lastname ?? ''} - ${con.order.client?.phone ?? ''}',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        trailing: const Icon(Icons.person),
      ),
    );
  }

  Widget _dataAddress() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: const Text(
          'Address Shipping',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          con.order.address?.address ?? '',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        trailing: const Icon(Icons.location_on),
      ),
    );
  }

  Widget _dataDate() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: const Text(
          'Order Date',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          RelativeTimeUtil.getRelativeTime(con.order.timestamp ?? 0),
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        trailing: const Icon(Icons.timer),
      ),
    );
  }

  Widget _cardProduct(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
      child: Row(
        children: [
          _imageProduct(product),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NimbusSans',
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Quantity: ${product.quantity}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                  fontStyle: FontStyle.italic,
                  fontFamily: 'NimbusSans',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return SizedBox(
      height: 50,
      width: 50,
      // padding: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage(
          image: product.image1 != null
              ? NetworkImage(product.image1!)
              : const AssetImage('assets/img/no-image.png') as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 50),
          placeholder: const AssetImage('assets/img/no-image.png'),
        ),
      ),
    );
  }

  Widget _totalToPay(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[400]),
        Container(
          margin: EdgeInsets.only(
              left: con.order.status == 'PAID' ? 20 : 37, top: 15),
          child: Row(
            mainAxisAlignment: con.order.status == 'PAID'
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Text(
                'TOTAL: \$${con.total.value}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              con.order.status == 'DISPATCHED'
                  ? _buttonUpdateOrder()
                  : con.order.status == 'ON THE WAY'
                      ? _buttonGoToOrderMap()
                      : Container()
            ],
          ),
        )
      ],
    );
  }

  Widget _buttonUpdateOrder() {
    return Container(
      margin: const EdgeInsets.only(left: 40),
      child: SizedBox(
        width: 180,
        height: 50,
        child: ElevatedButton(
            onPressed: () => con.updateOrder(),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                backgroundColor: Colors.cyan),
            child: const Text(
              'START DELIVERY',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'NimbusSans',
              ),
            )),
      ),
    );
  }

  Widget _buttonGoToOrderMap() {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(left: 40),
      child: SizedBox(
        width: 180,
        height: 50,
        child: ElevatedButton(
            onPressed: () => con.goToOrderMap(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreenAccent,
              padding: const EdgeInsets.only(top: 1.5, left: 20, right: 20),
            ),
            child: const Text(
              'RETURN TO MAP',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'NimbusSans',
                fontSize: 17,
              ),
            )),
      ),
    );
  }
}
