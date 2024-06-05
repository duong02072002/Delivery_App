import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/models/category.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/products/create/restaurant_products_create_controller.dart';
import 'package:get/get.dart';

class RestaurantProductsCreatePage extends StatelessWidget {
  RestaurantProductsCreateController con =
      Get.put(RestaurantProductsCreateController());

  RestaurantProductsCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            _backgroundCover(context),
            _boxForm(context),
            _buttonBack(),
            Column(
              children: [
                _textNewCategory(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: Colors.amber.shade500,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(33),
          bottomRight: Radius.circular(33),
        ),
      ),
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.83,
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.15, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 0.75),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // _textYourInfo(),
            const SizedBox(height: 5),
            _textYourInfo(),
            _textFieldName(),
            _textFieldDescription(),
            _textFieldPrice(),
            _dropDownCategories(con.categories),
            Container(
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetBuilder<RestaurantProductsCreateController>(
                      builder: (value) =>
                          _cardImage(context, con.imageFile1, 1)),
                  GetBuilder<RestaurantProductsCreateController>(
                      builder: (value) =>
                          _cardImage(context, con.imageFile2, 2)),
                  GetBuilder<RestaurantProductsCreateController>(
                      builder: (value) =>
                          _cardImage(context, con.imageFile3, 3)),
                ],
              ),
            ),
            _buttonCreate(context),
          ],
        ),
      ),
    );
  }

  Widget _buttonBack() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        child: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
    );
  }

  Widget _dropDownCategories(List<Category> categories) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 55, // Đặt chiều cao cho Container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.amber,
          ),
          elevation: 3,
          isExpanded: true,
          hint: const Text(
            'Select Category',
            style: TextStyle(fontSize: 17),
          ),
          items: _dropDownItems(categories),
          value: con.idCategory.value == '' ? null : con.idCategory.value,
          onChanged: (option) {
            print('Selected Option $option');
            con.idCategory.value = option.toString();
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories) {
    List<DropdownMenuItem<String>> list = [];
    for (var category in categories) {
      list.add(DropdownMenuItem(
        value: category.id,
        child: Text(category.name ?? ''),
      ));
    }

    return list;
  }

  Widget _cardImage(BuildContext context, File? imageFile, int numberFile) {
    return GestureDetector(
      onTap: () => con.showAlertDialog(context, numberFile),
      child: Card(
        margin: const EdgeInsets.only(top: 10, left: 3),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // bo tròn các góc của card
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20), // bo tròn các góc của card
          child: Container(
            padding: const EdgeInsets.all(6),
            height: 100,
            width: MediaQuery.of(context).size.width * 0.29,
            color: Colors.white,
            child: imageFile != null
                ? ClipRRect(
                    borderRadius:
                        BorderRadius.circular(15), // bo tròn các góc của ảnh
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Image(
                    image: AssetImage('assets/img/cover_image.png'),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _textFieldName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        controller: con.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Name',
          prefixIcon: const Icon(Icons.category),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _textFieldPrice() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        controller: con.priceController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Price',
          prefixIcon: const Icon(Icons.attach_money),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _textFieldDescription() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        controller: con.descriptionController,
        keyboardType: TextInputType.text,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Description',
          prefixIcon: const Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: ElevatedButton(
        onPressed: () {
          con.createProduct(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          'CREATE PRODUCT',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _textNewCategory(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 48),
      alignment: Alignment.center,
      child: const Text(
        'NEW PRODUCT',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 10),
      child: const Text(
        'PRODUCT',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }
}
