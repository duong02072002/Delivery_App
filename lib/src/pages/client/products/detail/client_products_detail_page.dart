import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/client/products/detail/client_products_detail_controller.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Thêm import này

import '../../../../models/product.dart';

class ClientProductsDetailPage extends StatelessWidget {
  Product? product;
  late ClientProductsDetailController con;
  var counter = 1.obs;
  var price = 0.0.obs;

  ClientProductsDetailPage({super.key, @required this.product}) {
    con = Get.put(ClientProductsDetailController());
  }

  @override
  Widget build(BuildContext context) {
    con.checkIfProductsWasAdded(product!, price, counter);
    return Obx(() => Scaffold(
          bottomNavigationBar: Container(
              color: const Color.fromRGBO(245, 245, 245, 1.5),
              height: 100,
              child: _buttonsAddToBag()),
          body: Column(
            children: [
              _imageSlideshow(context),
              _textNameProduct(),
              _textDescriptionProduct(),
              _textPriceProduct()
            ],
          ),
        ));
  }

  Widget _textNameProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Text(
        product?.name ?? '',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _textDescriptionProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 30, left: 20, right: 10),
      child: Text(
        product?.description ?? '',
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _textPriceProduct() {
    final formatter = NumberFormat("#,##0.00", "en_US"); // Tạo định dạng số

    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 10, left: 20, right: 30),
      child: Text(
        '\$${formatter.format(product?.price ?? 0)}', // Định dạng giá trị số
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buttonsAddToBag() {
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
          margin: const EdgeInsets.only(left: 4, right: 3, top: 20),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () => con.removeItem(product!, price, counter),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(45, 50),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                  ),
                  backgroundColor: Colors.white70,
                ),
                child: const Text(
                  '-',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(45, 50),
                  backgroundColor: Colors.white70,
                ),
                child: Text(
                  '${counter.value}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => con.addItem(product!, price, counter),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(45, 50),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  backgroundColor: Colors.white70,
                ),
                child: const Text(
                  '+',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => con.addToBag(product!, price, counter),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: const Size(45, 55),
                  backgroundColor: Colors.amber,
                ),
                child: SizedBox(
                  width: 160, // Chiều rộng tùy chỉnh
                  height: 50, // Chiều cao tùy chỉnh
                  child: Center(
                    child: Text(
                      'Add To Cart  \$${formatter.format(price.value)}', // Định dạng giá trị số
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NimbusSans',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _imageSlideshow(BuildContext context) {
    return ImageSlideshow(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      initialPage: 0,
      indicatorColor: Colors.amber,
      indicatorBackgroundColor: Colors.grey,
      children: [
        FadeInImage(
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 50),
            placeholder: const AssetImage('assets/img/no-image.png'),
            image: product!.image1 != null
                ? NetworkImage(product!.image1!)
                : const AssetImage('assets/img/no-image.png') as ImageProvider),
        FadeInImage(
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 50),
            placeholder: const AssetImage('assets/img/no-image.png'),
            image: product!.image2 != null
                ? NetworkImage(product!.image2!)
                : const AssetImage('assets/img/no-image.png') as ImageProvider),
        FadeInImage(
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 50),
            placeholder: const AssetImage('assets/img/no-image.png'),
            image: product!.image3 != null
                ? NetworkImage(product!.image3!)
                : const AssetImage('assets/img/no-image.png') as ImageProvider),
      ],
    );
  }
}
