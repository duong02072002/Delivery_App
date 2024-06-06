import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/client/orders/create/client_orders_create_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Thêm import này

import '../../../../models/product.dart';
import '../../../../widgets/no_data_widget.dart';

class ClientOrdersCreatePage extends StatelessWidget {
  ClientOrdersCreateController con = Get.put(ClientOrdersCreateController());

  ClientOrdersCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: Container(
          color: const Color.fromRGBO(245, 245, 245, 1),
          height: 100,
          child: _totalToPay(context),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(42),
          child: AppBar(
            backgroundColor: Colors.amber[500],
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'My Order',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: con.selectedProducts.isNotEmpty
            ? ListView(
                children: con.selectedProducts.map((Product product) {
                  return _cardProduct(product);
                }).toList(),
              )
            : Center(
                child: NoDataWidget(text: 'There Are No Products Added Yet'),
              ),
      ),
    );
  }

  Widget _totalToPay(BuildContext context) {
    final formatter = NumberFormat("#,##0.00", "en_US"); // Tạo định dạng số

    return Column(
      children: [
        Divider(
          height: 3,
          thickness: 3,
          color: Colors.grey[300],
          indent: 1,
          endIndent: 1,
        ),
        Container(
          margin: const EdgeInsets.only(left: 28, top: 3),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Sắp xếp phần tử ở hai đầu
            children: [
              Text(
                '      TOTAL:                                      \$${formatter.format(con.total.value)}', // Định dạng giá trị số
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => con.goToAddressList(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                    backgroundColor: Colors.amber,
                  ),
                  child: const Text(
                    'CHECKOUT',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
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

  Widget _cardProduct(Product product) {
    final formatter = NumberFormat("#,##0.00", "en_US"); // Tạo định dạng số

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _imageProduct(product),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 7),
              _buttonsAddOrRemove(product)
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _textPrice(product),
              _iconDelete(product),
            ],
          )
        ],
      ),
    );
  }

  Widget _iconDelete(Product product) {
    return IconButton(
        onPressed: () => con.deleteItem(product),
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ));
  }

  Widget _textPrice(Product product) {
    final formatter = NumberFormat("#,##0.00", "en_US"); // Tạo định dạng số

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Text(
        '\$${formatter.format(product.price! * product.quantity!)}', // Định dạng giá trị số
        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buttonsAddOrRemove(Product product) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => con.removeItem(product),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                )),
            child: const Text('-'),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          color: Colors.grey[200],
          child: Text('${product.quantity ?? 0}'),
        ),
        GestureDetector(
          onTap: () => con.addItem(product),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
            child: const Text('+'),
          ),
        ),
      ],
    );
  }

  Widget _imageProduct(Product product) {
    return SizedBox(
      height: 70,
      width: 70,
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
}
