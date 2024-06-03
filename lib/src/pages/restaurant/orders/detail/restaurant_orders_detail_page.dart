import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:get/get.dart';

import '../../../../models/product.dart';
import '../../../../models/user.dart';
import '../../../../utils/relative_time_util.dart';
import '../../../../widgets/no_data_widget.dart';

class RestaurantOrdersDetailPage extends StatelessWidget {
  RestaurantOrdersDetailController con =
      Get.put(RestaurantOrdersDetailController());

  RestaurantOrdersDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          bottomNavigationBar: Container(
            color: const Color.fromRGBO(245, 245, 245, 1),
            height: con.order.status == 'PAID'
                ? MediaQuery.of(context).size.height * 0.50
                : MediaQuery.of(context).size.height * 0.44,
            //padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                _dataDate(),
                _dataClient(),
                _dataAddress(),
                _dataDelivery(),
                _totalToPay(context),
              ],
            ),
          ),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40),
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

  Widget _dataDelivery() {
    return con.order.status != 'PAID'
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              title: const Text(
                'Assigned Delivery Driver',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${con.order.delivery?.name ?? ''} ${con.order.delivery?.lastname ?? ''} - ${con.order.delivery?.phone ?? ''}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              trailing: const Icon(Icons.delivery_dining),
            ),
          )
        : Container();
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
        if (con.order.status == 'PAID') ...[
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 36, vertical: 7),
            child: Text(
              'ASSIGN DELIVERY MAN',
              style: TextStyle(
                color: Colors.amber[700],
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          _dropDownDeliveryMen(con.users),
        ],
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
              if (con.order.status == 'PAID')
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: ElevatedButton(
                    onPressed: () => con.updateOrder(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.fromLTRB(
                          45, 15, 45, 10), // Adjusted padding
                    ),
                    child: const Text(
                      'SEND ORDER',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NimbusSans',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dropDownDeliveryMen(List<User> users) {
    return Container(
      //padding: const EdgeInsets.symmetric(horizontal: 44),
      //margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
      margin: const EdgeInsets.only(left: 40, right: 40.5, bottom: 15),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.topRight,
          child: const Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.amber,
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: const Text(
          'Select Delivery Person',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        items: _dropDownItems(users),
        value: con.idDelivery.value == '' ? null : con.idDelivery.value,
        onChanged: (option) {
          print('Selected Option $option');
          con.idDelivery.value = option.toString();
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    for (var user in users) {
      list.add(DropdownMenuItem(
        value: user.id,
        child: Row(
          children: [
            SizedBox(
              height: 35,
              width: 35,
              child: FadeInImage(
                image: user.image != null
                    ? NetworkImage(user.image!)
                    : const AssetImage('assets/img/no-image.png')
                        as ImageProvider,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 50),
                placeholder: const AssetImage('assets/img/no-image.png'),
              ),
            ),
            const SizedBox(width: 15),
            Text(user.name ?? ''),
          ],
        ),
      ));
    }

    return list;
  }
}
