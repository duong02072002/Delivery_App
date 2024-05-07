import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  String text = '';

  NoDataWidget({super.key, this.text = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/zero-items.png',
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 15),
          Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
