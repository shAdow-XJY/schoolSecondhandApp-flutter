// ignore: import_of_legacy_library_into_null_safe
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shadow/common/global_data.dart';

double userWidth = 0.0;
double userLength = 0.0;

double transferWidth(double src) {
  if (userWidth != 0.0) {
    return userWidth / GlobalData.devWidth * src;
  }
  return src;
}

double transferlength(double src) {
  if (userWidth != 0.0) {
    return userLength / GlobalData.devheight * src;
  }
  return src;
}

String ecryptoMd5(String data) {
  var bytes = utf8.encode("foobar"); // data being hashed
  var digest = sha1.convert(bytes);
  return digest.toString();
}

bool checkPhone(String value) {
  RegExp reg = new RegExp(
      r'^((13[0-9])|(14[579])|(15([0-3,5-9]))|(16[6])|(17[0135678])|(18[0-9]|19[89]))\d{8}$');
  if (!reg.hasMatch(value)) {
    return false;
  } else {
    return true;
  }
}

bool checkEmail(String value) {
  RegExp reg = RegExp(r'^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$');
  if (!reg.hasMatch(value)) {
    return false;
  } else {
    return true;
  }
}

bool checkInstituteCode(String code) {
  RegExp reg = RegExp(
      r'^([159Y]{1})([1239]{1})([0-9ABCDEFGHJKLMNPQRTUWXY]{6})([0-9ABCDEFGHJKLMNPQRTUWXY]{9})([0-90-9ABCDEFGHJKLMNPQRTUWXY])$');
  if (!reg.hasMatch(code)) {
    return false;
  } else {
    return true;
  }
}

bool checkIdNumber(String code) {
  RegExp reg = RegExp(
      r'^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$');
  if (!reg.hasMatch(code)) {
    reg = RegExp(
        r'^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{2}$');
    if (!reg.hasMatch(code)) {
      return false;
    } else {
      return true;
    }
  } else {
    return true;
  }
}
