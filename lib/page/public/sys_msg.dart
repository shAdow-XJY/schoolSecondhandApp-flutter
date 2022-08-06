import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/service/message_service.dart';
import 'package:shadow/util/date_util.dart';

class SysMsgPage extends StatefulWidget {
  SysMsgPage({
    Key? key,
  }) : super(key: key);

  _OverdueUrgeReplyPageState createState() => _OverdueUrgeReplyPageState();
}

class _OverdueUrgeReplyPageState extends State<SysMsgPage> {
  ScrollController _scrollController = ScrollController(); //listview的控制器
  late double contentMaxWidth;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    initData();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      initData();
    });
  }

  initData() async {
    RResponse rResponse = await MessageService.listMessage(1);
    if (rResponse.code == 1) {
      list = [];
      for (var item in rResponse.data['msg']) {
        setState(() {
          list.add(item);
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    contentMaxWidth = MediaQuery.of(context).size.width - 90;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange.withOpacity(0.5),
        title: Text("系统消息"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFFF1F5FB),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                //列表内容少的时候靠上
                alignment: Alignment.topCenter,
                child: _renderList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List list = []; //列表要展示的数据

  _renderList() {
    return GestureDetector(
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 27),
        itemBuilder: (context, index) {
          var item = list[index];
          return GestureDetector(
            child: _renderRowSendByOthers(context, item),
            onTap: () {},
          );
        },
        itemCount: list.length,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  Widget _renderRowSendByOthers(BuildContext context, item) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        children: <Widget>[
          Padding(
            child: Text(
              transferTimeStamp(item['send_time'].toString()),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFA1A6BB),
                fontSize: 14,
              ),
            ),
            padding: EdgeInsets.only(bottom: 20),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 45),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Color(0xFF464EB5),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    child: Text(
                      "系统",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    padding: EdgeInsets.only(bottom: 2),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        child: Text(
                          "系统消息",
                          softWrap: true,
                          style: TextStyle(
                            color: Color(0xFF677092),
                            fontSize: 14,
                          ),
                        ),
                        padding: EdgeInsets.only(left: 20, right: 30),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            child: Image(
                                width: 11,
                                height: 20,
                                image: AssetImage(
                                    "assets/images/public/login/login.png")),
                            margin: EdgeInsets.fromLTRB(2, 16, 0, 0),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(4.0, 7.0),
                                    color: Color(0x04000000),
                                    blurRadius: 10,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: EdgeInsets.only(top: 8, left: 10),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              item['content'],
                              style: TextStyle(
                                color: Color(0xFF03073C),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final int maxValue = 1 << 32;
}
