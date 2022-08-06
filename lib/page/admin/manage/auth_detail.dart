/**
 * 认证信息页面,包含四个子页面
 * 1.展示
 * 2.展示
 * 3.申请
 * 4.申请
 */
import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shadow/common/list_item.dart';
import 'package:shadow/common/loading_diglog.dart';
import 'package:shadow/model/enterpeiseAuth.dart';
import 'package:shadow/model/studentAuth.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/service/admin_Service.dart';
import 'package:shadow/util/number_util.dart';

class AuthDetailPage extends StatefulWidget {
  Map arguments;

  AuthDetailPage({Key? key, required this.arguments}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthDetailPage> {
  TextEditingController mController = TextEditingController();
  int type = -1;
  late RResponse response;
  @override
  void initState() {
    super.initState();
    getAuthInfo();
  }

  getAuthInfo() async {
    RResponse rResponse = await AdminService.getAuthDetail(
        widget.arguments['id'], widget.arguments['auth_type']);
    response = rResponse;
    this.setState(() {
      if (rResponse.data["auth_type"] == "enterprise") {
        type = 1;
      } else if (rResponse.data["auth_type"] == "student") {
        type = 2;
      } else {
        type = 0;
      }
    });
  }

  int groupValue = 0;
  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 1:
        return _EnterpeiseWidget();
      case 2:
        return _LawerWidget();
      default:
        return Container(
          child: Scaffold(
            appBar: AppBar(
              title: Text("认证详情"),
              backgroundColor: Colors.orange.withOpacity(0.3),
            ),
          ),
        );
    }
  }

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text('提示'),
          content: new Text(message),
          actions: <Widget>[
            FlatButton(
              color: Colors.grey,
              highlightColor: Colors.blue[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              child: Text("确定"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _LawerWidget() {
    List<Widget> _list = [];
    _list.add(SizedBox(
      height: 15,
    ));

    StudentAuth studentAuth = response.data["student"];
    _list.add(ListItem(
        message: "申请人",
        widget: Text(
          widget.arguments['nick_name'],
          style: TextStyle(fontSize: 17),
        )));

    _list.add(ListItem(
        message: "认证类型",
        widget: Text(
          "学生",
          style: TextStyle(fontSize: 17),
        )));

    _list.add(ListItem(
        message: "认证申请时间",
        widget: Text(
          studentAuth.authTime!,
          style: TextStyle(fontSize: 17),
        )));

    _list.add(ListItem(
        message: "姓名",
        widget: Text(
          studentAuth.realName!,
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "性别",
        widget: Text(
          studentAuth.sex!,
          style: TextStyle(fontSize: 17),
        )));
    _list.add(SizedBox(
      height: 50,
    ));
    _list.add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Container(
        width: transferWidth(MediaQuery.of(context).size.width / 3),
        height: transferlength(45),
        child: RaisedButton(
          onPressed: () async {
            showDialog(context: context, builder: (context) => LoadingDialog());
            RResponse rResponse = await AdminService.handleAuth(
                "student", widget.arguments['id'], 0);
            Navigator.pop(context);
            if (rResponse.code != 1) {
              _showMessageDialog("处理失败,请重试");
            } else {
              Fluttertoast.showToast(
                  msg: "处理成功",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 17.0);
              Navigator.pop(context);
            }
          },
          shape: StadiumBorder(side: BorderSide.none),
          color: Colors.red.withOpacity(0.8),
          child: Text(
            '拒绝',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
      Container(
        width: transferWidth(MediaQuery.of(context).size.width / 3),
        height: transferlength(45),
        child: RaisedButton(
          onPressed: () async {
            showDialog(context: context, builder: (context) => LoadingDialog());
            RResponse rResponse = await AdminService.handleAuth(
                "student", widget.arguments['id'], 1);
            Navigator.pop(context);
            if (rResponse.code != 1) {
              _showMessageDialog("处理失败,请重试");
            } else {
              Fluttertoast.showToast(
                  msg: "处理成功",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 17.0);
              Navigator.pop(context);
            }
          },
          shape: StadiumBorder(side: BorderSide.none),
          color: Colors.green.withOpacity(0.7),
          child: Text(
            '同意认证',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      )
    ]));

    return Container(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange.withOpacity(0.5),
              brightness: Brightness.light,
              title: Text('认证信息'),
            ),
            body: ListView.builder(
                itemCount: _list
                    .length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
                itemBuilder: (content, index) {
                  return _list[index];
                })));
  }

  _EnterpeiseWidget() {
    List<Widget> _list = [];
    _list.add(SizedBox(
      height: 15,
    ));
    EnterpeiseAuth enterpeiseAuth = response.data["enterpeise"];
    _list.add(ListItem(
        message: "申请人",
        widget: Text(
          widget.arguments['nick_name'],
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "认证类型",
        widget: Text(
          "企业",
          style: TextStyle(fontSize: 17),
        )));

    _list.add(ListItem(
        message: "认证申请时间",
        widget: Text(
          enterpeiseAuth.authTime!,
          style: TextStyle(fontSize: 17),
        )));

    _list.add(ListItem(
        message: "企业名称",
        widget: Text(
          enterpeiseAuth.enterpriseName!,
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "企业地址",
        widget: Text(
          enterpeiseAuth.enterpriseAdd!,
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "企业代码",
        widget: Text(
          enterpeiseAuth.institutionCode!,
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(message: "企业经营执照:", widget: Text("")));
    _list.add(Image.network(
      enterpeiseAuth.businessLicenseUrl!,
      width: transferWidth(250),
      height: transferlength(250),
      fit: BoxFit.contain,
    ));
    _list.add(SizedBox(
      height: 50,
    ));
    _list.add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Container(
        width: transferWidth(MediaQuery.of(context).size.width / 3),
        height: transferlength(45),
        child: RaisedButton(
          onPressed: () async {
            showDialog(context: context, builder: (context) => LoadingDialog());
            RResponse rResponse = await AdminService.handleAuth(
                "enterprise", widget.arguments['id'], 0);
            Navigator.pop(context);
            if (rResponse.code != 1) {
              _showMessageDialog("处理失败,请重试");
            } else {
              Fluttertoast.showToast(
                  msg: "处理成功",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 17.0);
              Navigator.pop(context);
            }
          },
          shape: StadiumBorder(side: BorderSide.none),
          color: Colors.red.withOpacity(0.8),
          child: Text(
            '拒绝',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
      Container(
        width: transferWidth(MediaQuery.of(context).size.width / 3),
        height: transferlength(45),
        child: RaisedButton(
          onPressed: () async {
            showDialog(context: context, builder: (context) => LoadingDialog());
            RResponse rResponse = await AdminService.handleAuth(
                "enterprise", widget.arguments['id'], 1);
            Navigator.pop(context);
            if (rResponse.code != 1) {
              _showMessageDialog("处理失败,请重试");
            } else {
              Fluttertoast.showToast(
                  msg: "处理成功",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 17.0);
              Navigator.pop(context);
            }
          },
          shape: StadiumBorder(side: BorderSide.none),
          color: Colors.green.withOpacity(0.7),
          child: Text(
            '同意认证',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      )
    ]));
    return Container(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange.withOpacity(0.3),
              brightness: Brightness.light,
              title: Text('认证信息'),
            ),
            body: ListView.builder(
                itemCount: _list
                    .length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
                itemBuilder: (content, index) {
                  return _list[index];
                })));
  }
}
