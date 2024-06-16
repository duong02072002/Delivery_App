import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/restaurant/drivers/list/restaurant_drivers_list_controller.dart';
import 'package:get/get.dart';
import '../../../../models/user.dart';
import '../../../../widgets/no_data_widget.dart';

class RestaurantDriversListPage extends StatelessWidget {
  final RestaurantDriversListController con =
      Get.put(RestaurantDriversListController());

  RestaurantDriversListPage({super.key});

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
                  _listDriversTitle(),
                  const SizedBox(width: 150),
                  _iconStatistics(),
                  _iconAdd(),
                ],
              ),
            ),
            backgroundColor: Colors.amber[500],
          ),
        ),
        body: con.deliveryMen
                .isEmpty // Thay vì kiểm tra con.categories.isEmpty, chúng ta sẽ kiểm tra con.deliveryMen.isEmpty
            ? NoDataWidget(text: 'No Delivery Men Found')
            : ListView.builder(
                padding: const EdgeInsets.only(top: 13, left: 5, right: 5),
                itemCount: con.deliveryMen
                    .length, // Thay vì con.categories.length, chúng ta sẽ sử dụng con.deliveryMen.length
                itemBuilder: (_, index) {
                  return _cardDriver(context, con.deliveryMen[index]);
                },
              ),
      ),
    );
  }

  Widget _listDriversTitle() {
    return Container(
      padding: const EdgeInsets.only(top: 72),
      child: const Text(
        'LIST DRIVER',
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

  Widget _iconStatistics() {
    return IconButton(
      padding: const EdgeInsets.only(top: 65),
      onPressed: () => con.goToStatistics(),
      icon: const Icon(
        Icons.bar_chart,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget _cardDriver(BuildContext context, User driver) {
    return GestureDetector(
      onTap: () {
        // Hiển thị hộp thoại xác nhận trước khi xóa
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content:
                  const Text('Are you sure you want to delete this driver?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Gọi hàm deleteUser khi người dùng xác nhận muốn xóa
                    con.deleteUser(driver.id ?? '');
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(50), // Đảm bảo ảnh tròn
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: driver.image != null
                        ? // Kiểm tra nếu có ảnh đại diện của tài xế
                        Image.network(
                            driver.image!, // Sử dụng đường dẫn ảnh của tài xế
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.person,
                            size: 80,
                            color: Colors
                                .black), // Nếu không có ảnh, hiển thị một biểu tượng mặc định
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.name ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        driver.email ?? '',
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
