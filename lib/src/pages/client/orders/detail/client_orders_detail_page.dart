import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/client/orders/detail/client_orders_detail_controller.dart';
import 'package:get/get.dart';

import '../../../../models/product.dart';
import '../../../../utils/relative_time_util.dart';
import '../../../../widgets/no_data_widget.dart';

class ClientOrdersDetailPage extends StatelessWidget {
  ClientOrdersDetailController con = Get.put(ClientOrdersDetailController());

  ClientOrdersDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          bottomNavigationBar: Container(
            color: const Color.fromRGBO(245, 245, 245, 1),
            height: con.order.status == 'ON THE WAY'
                ? MediaQuery.of(context).size.height * 0.37
                : MediaQuery.of(context).size.height * 0.35,
            //padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                _dataDate(),
                _dataDelivery(),
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

  Widget _dataDelivery() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: const Text(
          'Deliveryman and Telephone',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${con.order.delivery?.name ?? 'Not Assigned'} ${con.order.delivery?.lastname ?? ''} - ${con.order.delivery?.phone ?? '###'}',
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
              left: con.order.status == 'ON THE WAY' ? 20 : 37, top: 15),
          child: Row(
            mainAxisAlignment: con.order.status == 'ON THE WAY'
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Text(
                'TOTAL: \$${con.total.value}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              con.order.status == 'ON THE WAY'
                  ? _buttonGoToOrderMap()
                  : Container()
            ],
          ),
        )
      ],
    );
  }

  Widget _buttonGoToOrderMap() {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: ElevatedButton(
          onPressed: () => con.goToOrderMap(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: const EdgeInsets.only(top: 4, left: 20, right: 20),
          ),
          child: const Text(
            'FOLLOW DELIVERY',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans',
              fontSize: 18,
            ),
          )),
    );
  }
}
