import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/models/category.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/categories/list/restaurant_categories_list_controller.dart';
import 'package:get/get.dart';
import '../../../../widgets/no_data_widget.dart';

class RestaurantCategoriesListPage extends StatelessWidget {
  final RestaurantCategoriesListController con =
      Get.put(RestaurantCategoriesListController());

  RestaurantCategoriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            flexibleSpace: Container(
              alignment: Alignment.topCenter,
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  _listCategoryTitle(),
                  const SizedBox(width: 170),
                  _iconAdd(),
                ],
              ),
            ),
            backgroundColor: Colors.amber[500],
          ),
        ),
        body: con.categories.isEmpty
            ? NoDataWidget(text: 'Without Categories')
            : ListView.builder(
                padding: const EdgeInsets.only(top: 13, left: 5, right: 5),
                itemCount: con.categories.length,
                itemBuilder: (_, index) {
                  return _cardCategory(context, con.categories[index]);
                },
              ),
      ),
    );
  }

  Widget _listCategoryTitle() {
    return Container(
      padding: const EdgeInsets.only(top: 72),
      child: const Text(
        'LIST CATEGORY',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'NimbusSans',
        ),
      ),
    );
  }

  Widget _iconAdd() {
    return IconButton(
      padding: const EdgeInsets.only(top: 65),
      onPressed: () => con.goToCreateCategories(),
      icon: const Icon(
        Icons.add,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget _cardCategory(BuildContext context, Category category) {
    return GestureDetector(
      //onTap: () => con.openBottomSheet(context, category),
      child: Container(
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Icon(Icons.category, size: 40, color: Colors.black),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        category.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
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
}
