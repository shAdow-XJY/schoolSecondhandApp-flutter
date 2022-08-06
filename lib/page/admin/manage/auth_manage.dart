import 'package:flutter/material.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/service/admin_service.dart';
import 'package:shadow/util/date_util.dart';

class AuthManagePage extends StatefulWidget {
  const AuthManagePage({Key? key}) : super(key: key);

  @override
  _AuthManagePageState createState() => _AuthManagePageState();
}

class _AuthManagePageState extends State<AuthManagePage> {
  List<Widget> _list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  initData() async {
    _list.add(SizedBox(
      height: 10,
    ));
    RResponse rResponse = await AdminService.getAuthList();
    if (rResponse.code == 1) {
      List<dynamic> list = rResponse.data['authers'];
      if (list.length != _list.length) {
        _list = [];
        list.forEach((element) {
          this.setState(() {
            _list.add(_ListItem(
                callback: () {
                  Navigator.pushNamed(context, "/admin/manage/auth/detail",
                      arguments: {
                        "id": element['id'],
                        "auth_type": element["auth_type"],
                        "nick_name": element['nick_name']
                      });
                },
                subtile: transferTimeStamp(element['auth_time'].toString()),
                type: element['auth_type'] == "student" ? 1 : 0,
                title: element['nick_name']));
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "认证管理",
        ),
        backgroundColor: Colors.orange.withOpacity(0.3),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _list
              .length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
          itemBuilder: (content, index) {
            return _list[index];
          }),
    );
  }
}

class _ListItem extends StatelessWidget {
  String title;
  String subtile;
  dynamic callback;
  int type;
  _ListItem({
    Key? key,
    required this.subtile,
    required this.type,
    this.callback,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              type == 0 ? Icons.spa : Icons.gesture,
              size: 30,
            ),
            subtitle: Text(
              "申请日期:     " + subtile,
            ),
            title: Text(
              "申请人:   " + title,
              style: TextStyle(fontSize: 20),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 25,
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
