import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shadow/common/list_item.dart';
import 'package:shadow/common/loading_diglog.dart';
import 'package:shadow/common/service_list_item.dart';
import 'package:shadow/model/response.dart';

import 'package:shadow/service/admin_Service.dart';
import 'package:shadow/service/deal_service.dart';
import 'package:shadow/util/date_util.dart';
import 'package:shadow/util/number_util.dart';

class DealDetailHandlePage extends StatefulWidget {
  DealDetailHandlePage({Key? key, required this.arguments}) : super(key: key);
  Map arguments;

  @override
  _DealDetailPageState createState() => _DealDetailPageState();
}

class _DealDetailPageState extends State<DealDetailHandlePage> {
  List<Widget> _list = [];

  @override
  void initState() {
    super.initState();
    _list.add(SizedBox(
      height: 20,
    ));
    _getDetail();
  }

  bool _show = false;
  _getDetail() async {
    RResponse rResponse =
    await DealService.getDealDetail(widget.arguments['id']);
    if (rResponse.code == 1) {
      _list.removeRange(1, _list.length);
      Map r = rResponse.data['deal_detail'];
      this.setState(() {
        _list.add(ListItem(message: "订单名称", widget: Text(r["deal_name"])));
        _list.add(ListItem(message: "订单类型", widget: Text(r["deal_type"])));
        _list.add(ListItem(
          message: "申请人",
          widget: InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             ProposerDetailPage(proposerInfo: r['enterprise'])));
            },
            child: Text(
              r['from_name'],
              style:
              TextStyle(color: Colors.blue, letterSpacing: 3, fontSize: 18),
            ),
          ),
        ));
        if (r['status'] == 2 || r['status'] == 3) {
          _list.add(ListItem(
              message: "承接人",
              widget: InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             LawerInfoPage(map: r['student'])));
                  },
                  child: Text(
                    "${r["student"]['real_name']}",
                    style: TextStyle(
                        color: Colors.blue, letterSpacing: 3, fontSize: 18),
                  ))));
        }
        _list.add(ListItem(
            message: "申请时间",
            widget: Text(transferTimeStamp(r['commit_time'].toString()))));
        _list.add(ListItem(
            message: "结束时间",
            widget: Text(transferTimeStamp(r['end_time'].toString()))));
        _list.add(ListItem(
            message: "服务方案",
            widget: InkWell(
              onTap: () {
                this.setState(() {
                  _show = !_show;
                });
              },
              child: Icon(
                _show
                    ? Icons.arrow_drop_up_outlined
                    : Icons.arrow_drop_down_outlined,
                size: 40,
              ),
            )));
        _list.add(!_show
            ? Container()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ServiceListItem(
              message: "服务等级",
              widget: Text(
                "${r['service']['level']}",
              ),
            ),
            ServiceListItem(
              message: "服务价格",
              widget: Text(
                "${r['service']['price']}/月",
              ),
            ),
            ServiceListItem(
              message: "服务名称",
              widget: Text(
                "${r['service']['service_name']}",
              ),
            ),
            ServiceListItem(
              message: "服务内容",
              widget: Text(
                "${r['service']['service_content']}",
              ),
            ),
          ],
        ));
        String status = "管理审核中";
        switch (r['status']) {
          case -1:
            status = "已拒绝";
            break;
          case 2:
            status = "律师审核中";
            break;
          case 3:
            status = "进行中";
            break;
          case 3:
            status = "已结束";
            break;
        }
        _list.add(ListItem(message: "订单具体内容", widget: Text("")));
        _list.add(Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                border:
                Border.all(width: 1, color: Colors.black.withOpacity(0.5)),
              ),
              child: Text(
                r["deal_content"],
                maxLines: 13,
              )),
        ));
        _list.add(ListItem(
            message: "订单文档",
            widget: InkWell(child: Icon(Icons.arrow_forward_ios))));
        _list.add(SizedBox(
          height: 30,
        ));
        _list.add(
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(
                width: transferWidth(MediaQuery.of(context).size.width / 3),
                height: transferlength(45),
                child: RaisedButton(
                  onPressed: () async {
                    showDialog(
                        context: context, builder: (context) => LoadingDialog());
                    RResponse rResponse = await AdminService.handleDeal(widget.arguments['id'], false);
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
                    showDialog(
                        context: context, builder: (context) => LoadingDialog());
                    RResponse rResponse = await AdminService.handleDeal(widget.arguments['id'], true);
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
                    '同意申请',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              )
            ]));
        _list.add(SizedBox(
          height: 30,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //_getDetail();
    return Scaffold(
        appBar: AppBar(
          title: Text("订单详情"),
          backgroundColor: Colors.orange.withOpacity(0.5),
        ),
        body: ListView.builder(
            itemCount: _list
                .length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
            itemBuilder: (content, index) {
              return _list[index];
            }));
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
}