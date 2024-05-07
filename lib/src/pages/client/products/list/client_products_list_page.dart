import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/models/category.dart';
import 'package:flutter_delivery_app/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:get/get.dart';
import '../../../../models/product.dart';
import '../../../../widgets/no_data_widget.dart';

class ClientProductsListPage extends StatelessWidget {
  final ClientProductsListController con =
      Get.put(ClientProductsListController());

  ClientProductsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: con.categories.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: AppBar(
              flexibleSpace: Container(
                margin: const EdgeInsets.only(top: 15),
                alignment: Alignment.topCenter,
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [
                    _textFieldSearch(context),
                    _iconShoppingBag(),
                  ],
                ),
              ),
              backgroundColor: Colors.amber[600],
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                labelColor: Colors.black,
                unselectedLabelColor: const Color.fromARGB(255, 244, 240, 240),
                tabs: List<Widget>.generate(con.categories.length, (index) {
                  return Tab(
                    child: Text(
                      con.categories[index].name ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'NimbusSans',
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          body: TabBarView(
            children: con.categories.map((Category category) {
              return FutureBuilder(
                  future: con.getProducts(
                      category.id ?? '1', con.productName.value),
                  builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return GridView.builder(
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 10, vertical: 20),
                            padding: const EdgeInsets.only(
                                top: 12, left: 8, right: 8),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 0.75),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              return _cardProduct(
                                  context, snapshot.data![index]);
                            });
                      } else {
                        return NoDataWidget(text: 'Without Product');
                      }
                    } else {
                      return NoDataWidget(text: 'Without Product');
                    }
                  });
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _iconShoppingBag() {
    return SafeArea(
      child: Container(
        //margin: const EdgeInsets.only(left: 10),
        child: con.items.value > 0
            ? Stack(
                children: [
                  IconButton(
                      onPressed: () => con.goToOrderCreate(),
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 33,
                        color: Colors.black,
                      )),
                  Positioned(
                      right: 4,
                      top: 12,
                      child: Container(
                        width: 16,
                        height: 16,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Text(
                          '${con.items.value}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ))
                ],
              )
            : IconButton(
                onPressed: () => con.goToOrderCreate(),
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 30,
                  color: Colors.black,
                )),
      ),
    );
  }

  Widget _textFieldSearch(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.80,
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
              contentPadding: const EdgeInsets.all(15)),
        ),
      ),
    );
  }

  Widget _cardProduct(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        con.openBottomSheet(context, product);
      },
      child: SizedBox(
        height: 250,
        child: Card(
          elevation: 3.0,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Positioned(
                  top: -1.0,
                  right: -1.0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(20),
                        )),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    margin: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: const EdgeInsets.all(20),
                    child: product.image1 != null
                        ? FadeInImage(
                            image: NetworkImage(product.image1!),
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 300),
                            placeholder:
                                const AssetImage('assets/img/no-image.png'),
                          )
                        : const Icon(
                            Icons.image_not_supported,
                            size: 60,
                            color: Colors.grey,
                          ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 33,
                    child: Text(
                      product.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'NimbusSans',
                      ),
                    ),
                  ),
                  //const Spacer(),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      '${product.price ?? 0}\$',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NimbusSans',
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
