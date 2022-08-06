import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/service/deal_service.dart';
import 'package:shadow/util/number_util.dart';
import 'package:unicorndial/unicorndial.dart';

class myDealPage extends StatefulWidget {
  @override
  _myDealPageState createState() => _myDealPageState();
}

class _myDealPageState extends State<myDealPage> {

  List<ExpansionpanelItem> items = <ExpansionpanelItem>[];
  List<ExpansionpanelItem> enditems = <ExpansionpanelItem>[];

  List<ExpansionpanelItem> giveitems = <ExpansionpanelItem>[];
  @override
  void initState() {
    super.initState();
    getMyDeals();
    // getDealDetail(widget.arguments);
  }

  getMyDeals() async {
    RResponse rResponse = await DealService.listMyDeals();
    if (rResponse.code == 1) {
      this.setState(() {
        for (var item in rResponse.data['deals']) {
          if(item['status'] == 1){
            items.add(
              ExpansionpanelItem(
                isExpanded: false,
                title: item['deal_name'],
                content: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
                    child: Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('卖家: ' + item['from_name']),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('价格: ' + item['total_money'].toString()),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('发布时间: ' + item['modify_time']),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('物品详情: ' + item['deal_content']),
                        ],
                      ),
                      //put the children here
                    ])),
                //leading: Icon(Icons.image)
              ),
            );
          }
          else if(item['status'] == 2){
            enditems.add(
              ExpansionpanelItem(
                isExpanded: false,
                title: item['deal_name'],
                content: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
                    child: Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('卖家: ' + item['from_name']),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('价格: ' + item['total_money'].toString()),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('结束时间: ' + item['end_time'].toString()),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('物品详情: ' + item['deal_content']),
                        ],
                      ),
                      //put the children here
                    ])),
                //leading: Icon(Icons.image)
              ),
            );
          }

        }

      });
    }
  }

  @override
  Widget build(BuildContext context) {
      var childButtons = List<UnicornButton>.empty(growable: true);  //见Readme

      childButtons.add(UnicornButton(
          hasLabel: true,
          labelText: "捐赠",
          currentButton: FloatingActionButton(
            heroTag: "give",
            backgroundColor: Colors.redAccent,
            mini: true,
            child: Icon(Icons.local_shipping),
            onPressed: () {},
          )));

      childButtons.add(UnicornButton(
          hasLabel: true,
          labelText: "收购",
          currentButton: FloatingActionButton(
              heroTag: "buy",
              backgroundColor: Colors.greenAccent,
              mini: true,
              onPressed: () {  },
              child: Icon(Icons.local_grocery_store))));

      childButtons.add(UnicornButton(
          hasLabel: true,
          labelText: "出售",
          currentButton: FloatingActionButton(
              heroTag: "sell",
              backgroundColor: Colors.blueAccent,
              mini: true,
              onPressed: () {
                Navigator.pushNamed(context, "/createdeal");
              },
              child: Icon(Icons.monetization_on))));

      return Scaffold(
          floatingActionButton: UnicornDialer(
              backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
              parentButtonBackground: Colors.redAccent,
              orientation: UnicornOrientation.VERTICAL,
              parentButton: Icon(Icons.add),
              childButtons: childButtons),

        // backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              ExpansionTile(
                title: Text(
                  "发布的订单",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        items[index].isExpanded = !items[index].isExpanded;
                      });
                    },
                    children: items.map((ExpansionpanelItem item) {
                      return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                              //leading: item.leading,
                              title: Text(
                                item.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ));
                        },
                        isExpanded: item.isExpanded,
                        body: item.content,
                      );
                    }).toList(),
                  ),

                ],
              ),
              SizedBox(height: 20.0),
              ExpansionTile(
                title: Text(
                  "已结束的订单",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        enditems[index].isExpanded = !enditems[index].isExpanded;
                      });
                    },
                    children: enditems.map((ExpansionpanelItem item) {
                      return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                              //leading: item.leading,
                              title: Text(
                                item.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ));
                        },
                        isExpanded: item.isExpanded,
                        body: item.content,
                      );
                    }).toList(),
                  ),

                ],
              ),
              SizedBox(height: 20.0),
              ExpansionTile(
                title: Text(
                  "捐赠",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        giveitems[index].isExpanded = !giveitems[index].isExpanded;
                      });
                    },
                    children: giveitems.map((ExpansionpanelItem item) {
                      return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                              //leading: item.leading,
                              title: Text(
                                item.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ));
                        },
                        isExpanded: item.isExpanded,
                        body: item.content,
                      );
                    }).toList(),
                  ),

                ],
              ),
            ],
          ),
        ),

      );
    }

}

class ExpansionpanelItem {
  bool isExpanded;
  final String title;
  final Widget content;
  //final Icon leading;
  ExpansionpanelItem({required this.isExpanded, required this.title, required this.content});
}