import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/service/deal_service.dart';
import 'package:shadow/util/date_util.dart';

class dealDetailScreen extends StatefulWidget {
  Map arguments;
  dealDetailScreen({key, required this.arguments}) : super(key: key);

  @override
  _dealDetailScreen createState() => _dealDetailScreen();
}


var COLORS = [
  Color(0xFFEF7A85),
  Color(0xFFFF90B3),
  Color(0xFFFFC2E2),
  Color(0xFFB892FF),
  Color(0xFFB892FF)
];

class _dealDetailScreen extends State<dealDetailScreen> {
  var dealDetail = {};
  int fromID = 0;
  String pictureURL = "";

  @override
  void initState() {
    super.initState();
    getDealDetail(widget.arguments);
  }

  getDealDetail(Map arguments) async {
    RResponse rResponse = await DealService.getDealDetail(arguments['dealID'] as int);
    if (rResponse.code == 1) {
      this.setState(() {
          var item = rResponse.data['deal_detail'];
          dealDetail = {
            "id": item['id'],
            "from_id": item['from_id'],
            "from_name": item['from_name'],
            "deal_name": item['deal_name'],
            "deal_content": item['deal_content'],
            "service_name": item['service']['service_name'],
            "commit_time": item['commit_time'],
            "end_time": item['end_time'],
            "deal_type": item['deal_type'],
            "create_time": item['create_time'],
            "modify_time": item['modify_time'],
            "status": item['status'],
            "picture_url": item['picture_url']
          };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: COLORS[new Random().nextInt(5)],
        body: Stack(alignment: Alignment.center, children: [
          Positioned(
            top: 40,
            left: 1,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 30)),
          ),
          // Positioned(
          //     top: 90,
          //     left: 20,
          //     child: Text(
          //       dealDetail['deal_name'],
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontWeight: FontWeight.bold,
          //         fontSize: 30,
          //       ),
          //     )),
          // Positioned(
          //     top: 140,
          //     left: 20,
          //     child: Container(
          //       child: Padding(
          //         padding: const EdgeInsets.only(
          //             left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
          //         child: Text(dealDetail['from_name'],
          //             style: TextStyle(color: Colors.white)),
          //       ),
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(10),
          //           ),
          //           color: Colors.black26),
          //     )),
          // Positioned(
          //     top: height * 0.18,
          //     right: -30,
          //     child: Image.asset("assets/images/2.jpg",
          //         height: 200, fit: BoxFit.fitHeight)),
          Positioned(
            bottom: 0,
            child: Container(
                width: width,
                height: height * 0.6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height:30 ,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width:width*0.3,
                              child: Text("物品",style:TextStyle(
                                color:Colors.blueGrey,fontSize:18,
                              )),),
                            Container(
                              child: Text(dealDetail['deal_name'],style:TextStyle(
                                  color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold
                              )),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width:width*0.3,
                              child: Text("类型",style:TextStyle(
                                color:Colors.blueGrey,fontSize:18,
                              )),),
                            Container(
                              child: Text(dealDetail['service_name'],style:TextStyle(
                                  color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold
                              )),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width:width*0.3,
                              child: Text("交易",style:TextStyle(
                                color:Colors.blueGrey,fontSize:18,
                              )),),
                            Container(
                              child: Text(dealDetail['deal_type'],style:TextStyle(
                                  color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold
                              )),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width:width*0.3,
                              child: Text("卖家",style:TextStyle(
                                color:Colors.blueGrey,fontSize:18,
                              )),),
                            Container(
                              child: Text(dealDetail['from_name'],style:TextStyle(
                                  color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold
                              )),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width:width*0.3,
                              child: Text("发布日期",style:TextStyle(
                                color:Colors.blueGrey,fontSize:18,
                              )),),
                            Container(
                              child: Text(
                                  DateTime.fromMicrosecondsSinceEpoch(dealDetail['modify_time']).toString(),
                                  style:TextStyle(
                                  color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold
                              )),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width:width*0.3,
                              child: Text("具体内容",style:TextStyle(
                                color:Colors.blueGrey,fontSize:18,
                              )),),
                            Container(
                              child: Text(dealDetail['deal_content'],style:TextStyle(
                                  color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold
                              )),)
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/msg/chat', arguments: {
                          "id": dealDetail['from_id'],
                          "contact_name": dealDetail['from_name']
                          });
                        },
                        shape: StadiumBorder(side: BorderSide.none),
                        color: Colors.orange,
                        child: Text(
                          '买家留言',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),

                    ],
                  ),
                )),
          ),
          Positioned(
              top: height * 0.18,
              left: (width / 2) - 100,
              right: 0,
              child: Hero(
                tag:dealDetail['deal_name'],
                child: CachedNetworkImage(
                    imageUrl: dealDetail['picture_url'],
                    height: 200,
                    fit: BoxFit.fitHeight),
              ))
        ]));
  }
}