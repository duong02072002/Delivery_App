import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/models/product.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/products/list/restaurant_products_list_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Thêm import này

import '../../../../widgets/no_data_widget.dart';

class RestaurantProductsListPage extends StatelessWidget {
  final RestaurantProductsListController con =
      Get.put(RestaurantProductsListController());

  RestaurantProductsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
              //margin: const EdgeInsets.only(top: 15),
              alignment: Alignment.topCenter,
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  _textFieldSearch(context),
                  _iconAdd(),
                ],
              ),
            ),
            backgroundColor: Colors.amber[500],
          ),
        ),
        body: con.products.isEmpty
            ? Center(child: NoDataWidget(text: 'Without Product'))
            : ListView.builder(
                padding: const EdgeInsets.only(top: 13, left: 5, right: 5),
                itemCount: con.products.length,
                itemBuilder: (_, index) {
                  return _cardProduct(context, con.products[index]);
                },
              ),
      ),
    );
  }

  Widget _textFieldSearch(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.84,
        height: 50,
        child: TextField(
          onChanged: con.onChangeText,
          decoration: InputDecoration(
            hintText: 'Search Product',
            suffixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            hintStyle: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            contentPadding: const EdgeInsets.all(15),
          ),
        ),
      ),
    );
  }

  Widget _iconAdd() {
    return IconButton(
      padding: const EdgeInsets.only(top: 65),
      onPressed: () => con.goToCreateProduct(),
      icon: const Icon(
        Icons.add,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget _cardProduct(BuildContext context, Product product) {
    final formatter = NumberFormat("#,##0.00", "en_US"); // Tạo định dạng số

    return GestureDetector(
      onTap: () {
        // Hiển thị hộp thoại xác nhận xóa sản phẩm
        _showDeleteConfirmationDialog(context, product.id!);
      },
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white, // Set color to white
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FadeInImage(
                    image: NetworkImage(product.image1!),
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                    placeholder: const AssetImage('assets/img/no-image.png'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NimbusSans',
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'NimbusSans',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '\$${formatter.format(product.price)}', // Định dạng giá trị số
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'NimbusSans',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Gọi hàm xóa sản phẩm từ controller
                con.deleteProduct(productId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
