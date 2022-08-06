import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  String message;
  Widget widget;
  ListItem({Key? key, required this.message, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: ListTile(
              title: Text(
                message,
                style: TextStyle(fontSize: 20),
              ),
              trailing: widget,
            ),
          ),
          Divider(
            thickness: 1.5,
            color: Colors.grey.withOpacity(0.2),
          )
        ],
      ),
    );
  }
}
