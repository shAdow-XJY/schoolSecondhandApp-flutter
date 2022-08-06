import 'package:flutter/material.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/service/admin_service.dart';
import 'package:shadow/service/deal_service.dart';
import 'package:shadow/util/date_util.dart';
import 'package:shadow/util/number_util.dart';

class DealHandleListPage extends StatefulWidget {
  const DealHandleListPage({Key? key}) : super(key: key);

  @override
  _DealPageState createState() => _DealPageState();
}

class _DealPageState extends State<DealHandleListPage> {
  List<Widget> _list = [];

  @override
  void initState() {
    super.initState();
    getDealData();
    _list.add(SizedBox(
      height: 10,
    ));
  }

  getDealData() async {
    RResponse rResponse = await AdminService.listDeal();
    if (rResponse.code == 1) {
      this.setState(() {
        _list.removeRange(1, _list.length);
        for (var item in rResponse.data['deals']) {
          _list.add(_ListItem(
            person: item['from_name'],
            title: item['deal_name'],
            subtitle: item['commit_time'].toString(),
            callback: () {
              Navigator.pushNamed(context, '/admin/manage/deal/detail',
                  arguments: {"id": item['deal_id']}).then((value) => getDealData());
            },
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //getDealData();
    return Scaffold(
        appBar: AppBar(
          title: Text("项目审核"),
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

class _ListItem extends StatelessWidget {
  String title;
  String subtitle;
  String person;
  dynamic callback;
  _ListItem(
      {Key? key,
      required this.person,
      required this.subtitle,
      this.callback,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.circle,
              size: 30,
            ),
            title: Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              "申请人:" + person + "    申请时间: " + subtitle,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
