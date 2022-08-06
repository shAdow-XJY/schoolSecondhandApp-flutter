import 'package:flutter/material.dart';
import 'package:shadow/common/list_item.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/service/user_service.dart';
import 'package:shadow/util/date_util.dart';
import 'package:shadow/util/number_util.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  @override
  _PersonalInfoPage createState() => _PersonalInfoPage();
}

class _PersonalInfoPage extends State<PersonalInfoPage> {
  List<Widget> _list = [];
  @override
  void initState() {
    super.initState();
    _list.add(SizedBox(
      height: 20,
    ));
    getInfo();
  }

  getInfo() async {
    RResponse rResponse = await UserService.getInfo();
    Map r = rResponse.data["basic_info"];
    if (rResponse.code == 1) {
      this.setState(() {
        _list.add(ListItem(
            message: "头像",
            widget: ClipOval(
              child: Image.network(
                r["cover"],
                fit: BoxFit.cover,
                width: transferWidth(70),
                height: transferlength(70),
              ),
            )));
        _list.add(ListItem(message: "通行证", widget: Text(r["passport"])));
        _list.add(ListItem(message: "用户名", widget: Text(r["nickname"])));
        _list.add(ListItem(message: "邮箱", widget: Text(r["email"])));
        _list.add(ListItem(message: "电话号码", widget: Text(r["phone"])));
        _list.add(ListItem(
            message: "注册时间",
            widget: Text(transferTimeStamp(r["register_time"].toString()))));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("个人信息"),
          backgroundColor: Colors.orange.withOpacity(0.5),
        ),
        body: ListView.builder(
            itemCount: _list
                .length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
            itemBuilder: (content, index) {
              return _list[index];
            }));
  }
}
