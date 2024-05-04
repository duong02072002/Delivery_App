import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/models/category.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../../../models/product.dart';
import '../../../../models/response_api.dart';
import '../../../../providers/categories_provider.dart';
import '../../../../providers/products_provider.dart';

class RestaurantProductsCreateController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CategoriesProvider categoriesProvider = CategoriesProvider();

  ImagePicker picker = ImagePicker();
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;

  var idCategory = ''.obs;
  List<Category> categories = <Category>[].obs;
  ProductsProvider productsProvider = ProductsProvider();

  RestaurantProductsCreateController() {
    getCategories();
  }

  void getCategories() async {
    var result = await categoriesProvider.getAll();
    categories.clear();
    categories.addAll(result);
  }

  void createProduct(BuildContext context) async {
    String name = nameController.text;
    String description = descriptionController.text;
    String price = priceController.text;
    print('NAME: $name');
    print('DESCRIPTION: $description');
    print('PRICE: $price');
    print('ID CATEGORY: $idCategory');
    ProgressDialog progressDialog = ProgressDialog(context: context);

    if (isValidForm(name, description, price)) {
      Product product = Product(
          name: name,
          description: description,
          price: double.parse(price),
          idCategory: idCategory.value);
      progressDialog.show(max: 100, msg: 'Wait A Minute...');

      List<File> images = [];
      images.add(imageFile1!);
      images.add(imageFile2!);
      images.add(imageFile3!);

      Stream stream = await productsProvider.create(product, images);
      stream.listen((res) {
        progressDialog.close();

        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        Get.snackbar('Process Finished', responseApi.message ?? '');
        if (responseApi.success == true) {
          clearForm();
        }
      });
    }
  }

  bool isValidForm(String name, String description, String price) {
    if (name.isEmpty) {
      Get.snackbar('Invalid Form', 'Enter The Name Of The Product');
      return false;
    }
    if (description.isEmpty) {
      Get.snackbar('Invalid Form', 'Enter The Product Description');
      return false;
    }
    if (price.isEmpty) {
      Get.snackbar('Invalid Form', 'Enter The Price Of The Product');
      return false;
    }
    if (idCategory.value == '') {
      Get.snackbar('Invalid Form', 'You Must Select The Product Category');
      return false;
    }

    if (imageFile1 == null) {
      Get.snackbar('Invalid Form', 'Select Image Number 1 Of The Product');
      return false;
    }
    if (imageFile2 == null) {
      Get.snackbar('Invalid Form', 'Select Image Number 2 Of The Product');
      return false;
    }
    if (imageFile3 == null) {
      Get.snackbar('Invalid Form', 'Select Image Number 2 Of The Product');
      return false;
    }

    return true;
  }

  Future selectImage(ImageSource imageSource, int numberFile) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      if (numberFile == 1) {
        imageFile1 = File(image.path);
      } else if (numberFile == 2) {
        imageFile2 = File(image.path);
      } else if (numberFile == 3) {
        imageFile3 = File(image.path);
      }

      update();
    }
  }

  void showAlertDialog(BuildContext context, int numberFile) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.gallery, numberFile);
        },
        child: const Text(
          'GALLERY',
          style: TextStyle(color: Colors.amber),
        ));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.camera, numberFile);
        },
        child: const Text(
          'CAMERA',
          style: TextStyle(color: Colors.amber),
        ));

    AlertDialog alertDialog = AlertDialog(
      title: const Text('Select An Option'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void clearForm() {
    nameController.text = '';
    descriptionController.text = '';
    priceController.text = '';
    imageFile1 = null;
    imageFile2 = null;
    imageFile3 = null;
    idCategory.value = '';
    update();
  }
}
