import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/service/deal_service.dart';


var COLORS = [
  Color(0xFFEF7A85),
  Color(0xFFFF90B3),
  Color(0xFFFFC2E2),
  Color(0xFFB892FF),
  Color(0xFFB892FF)
];

class dealSearchPage extends StatefulWidget {
  Map arguments;
  dealSearchPage({Key? key, required this.arguments}) : super(key: key);

  @override
  _dealSearchPageState createState() => _dealSearchPageState();
}


class _dealSearchPageState extends State<dealSearchPage> {
  var data = [
    // {
    //   "deal_name": "Hey Flutterers, See what I did with Flutter",
    //   "total_money": "This is just a text description of the item",
    //   "color": COLORS[new Random().nextInt(5)],
    //   "picture_url": "https://picsum.photos/200?random"
    // },
  ];

  @override
  void initState() {
    super.initState();
    getDeals(widget.arguments);
    print(data);
  }

  getDeals(Map arguments) async {
    RResponse rResponse = await DealService.listDeals(arguments['serviceName']);
    if (rResponse.code == 1) {
      this.setState(() {
        for (var item in rResponse.data['deals']){
          data.add(
              AwesomeListItem(
                deal_id: item['deal_id'],
                deal_name:item['deal_name'],
                total_money:item['total_money'],
                picture_url:item['picture_url'],
                color: COLORS[new Random().nextInt(5)],
              )
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => {
                Navigator.pop(context)
              },
            ),
          backgroundColor: Colors.orange.withOpacity(0.5),
          title: Text(widget.arguments['serviceName']),
        ),
        body:Container(
          color: Colors.white,
          child: new Transform.translate(
            offset: new Offset(0.0, 0.0),
            child: new ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              scrollDirection: Axis.vertical,
              primary: true,
              itemCount: data.length,
              itemBuilder: (BuildContext total_money, int index) {
                return data[index];
              },
            ),
          ),
        )
    );

  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height / 4.75);
    p.lineTo(0.0, size.height / 3.75);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class AwesomeListItem extends StatefulWidget {
  String deal_name;
  double total_money;
  Color color;
  String picture_url;
  int deal_id;
  AwesomeListItem({required this.deal_name, required this.total_money, required this.color, required this.picture_url, required this.deal_id});

  @override
  _AwesomeListItemState createState() => new _AwesomeListItemState();
}

class _AwesomeListItemState extends State<AwesomeListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
      Navigator.pushNamed(context, "/dealdetail", arguments: {"dealID":widget.deal_id});
    },
    child:Row(
      children: <Widget>[
        new Container(width: 10.0, height: 190.0, color: widget.color),
        new Expanded(
          child: new Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  widget.deal_name,
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: new Text(
                    widget.total_money.toString(),
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        new Container(
          height: 150.0,
          width: 150.0,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              new Transform.translate(
                offset: new Offset(50.0, 0.0),
                child: new Container(
                  height: 100.0,
                  width: 100.0,
                  color: widget.color,
                ),
              ),
              new Transform.translate(
                offset: Offset(10.0, 20.0),
                child: new Card(
                  elevation: 20.0,
                  child: new Container(
                    height: 120.0,
                    width: 120.0,
                    child: CachedNetworkImage(
                        imageUrl: widget.picture_url,
                        height: 9.5,
                        fit: BoxFit.fitHeight),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    )
    );

  }
}
