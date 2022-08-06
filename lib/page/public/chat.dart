import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/service/message_service.dart';
import 'package:shadow/util/date_util.dart';

class OverdueUrgeReplyPage extends StatefulWidget {
  Map arguments;
  OverdueUrgeReplyPage({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  _OverdueUrgeReplyPageState createState() => _OverdueUrgeReplyPageState();
}

class _OverdueUrgeReplyPageState extends State<OverdueUrgeReplyPage> {
  late TextEditingController textEditingController;
  ScrollController _scrollController = ScrollController(); //listview的控制器
  late double contentMaxWidth;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    initData();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      initData();
    });
  }

  initData() async {
    RResponse rResponse =
        await MessageService.listMessage(widget.arguments['id']);
    if (rResponse.code == 1) {
      list = [];
      this.setState(() {
        for (var item in rResponse.data['msg']) {
          list.add(item);
        }
      });
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
        title: Text(widget.arguments['contact_name']),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
                      constraints: BoxConstraints(
                        maxHeight: 100.0,
                        minHeight: 50.0,
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xFFF5F6FF),
                          borderRadius: BorderRadius.all(Radius.circular(2))),
                      child: TextField(
                        controller: textEditingController,
                        cursorColor: Color(0xFF464EB5),
                        maxLines: null,
                        maxLength: 200,
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 10.0, bottom: 10.0),
                          hintText: "回复",
                          hintStyle:
                              TextStyle(color: Color(0xFFADB3BA), fontSize: 15),
                        ),
                        style:
                            TextStyle(color: Color(0xFF03073C), fontSize: 15),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      alignment: Alignment.center,
                      height: 70,
                      child: Text(
                        '发送',
                        style: TextStyle(
                          color: Color(0xFF464EB5),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    onTap: () {
                      sendTxt();
                    },
                  ),
                ],
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
            child: item['sender_name'] != widget.arguments["contact_name"]
                ? _renderRowSendByMe(context, item)
                : _renderRowSendByOthers(context, item),
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
                      item['sender_name'][0],
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
                          item['sender_name'],
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

  Widget _renderRowSendByMe(BuildContext context, item) {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 15),
                alignment: Alignment.center,
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: Color(0xFF464EB5),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  child: Text(
                    item['sender_name'][0],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  padding: EdgeInsets.only(bottom: 2),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    child: Text(
                      item['sender_name'],
                      softWrap: true,
                      style: TextStyle(
                        color: Color(0xFF677092),
                        fontSize: 14,
                      ),
                    ),
                    padding: EdgeInsets.only(right: 20),
                  ),
                  Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      Container(
                        child: Image(
                          width: 11,
                          height: 20,
                          image: AssetImage(
                              "assets/images/public/login/login.png"),
                        ),
                        margin: EdgeInsets.fromLTRB(0, 16, 2, 0),
                      ),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          ConstrainedBox(
                            child: Container(
                              margin: EdgeInsets.only(top: 8, right: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(4.0, 7.0),
                                      color: Color(0x04000000),
                                      blurRadius: 10,
                                    ),
                                  ],
                                  color: Color(0xFF838CFF),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              padding: EdgeInsets.all(10),
                              child: Text(
                                item['content'],
                                softWrap: true,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            constraints: BoxConstraints(
                              maxWidth: contentMaxWidth,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  final int maxValue = 1 << 32;

  sendTxt() async {
    if (textEditingController.value.text.trim().length == 0) {
      return;
    }

    String message = textEditingController.value.text;
    textEditingController.text = '';
    MessageService.sendMsg(widget.arguments['id'], message);
  }

  addMessage(content) {
    int time = new DateTime.now().millisecondsSinceEpoch;
    setState(() {
      list.insert(0, {
        "createdAt": time,
      });
    });
  }
}
