import 'package:flutter/material.dart';

class LoadingDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      height: 45,
      width: 45,
      child: CircularProgressIndicator(color: Colors.grey),
    ));
  }
}
