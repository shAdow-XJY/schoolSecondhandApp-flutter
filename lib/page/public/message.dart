import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shadow/model/response.dart';
import 'package:shadow/service/message_service.dart';
import 'package:shadow/util/number_util.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Widget> _list = [];

  @override
  void initState() {
    super.initState();
    _list.add(SizedBox(
      height: 10,
    ));
    _list.add(_ListItem(
      cover:
          "https://img-blog.csdnimg.cn/f4a80f2e4efb42d4b8d64f4d7ab789d0.jpg",
      title: "系统消息",
      subtitle: "",
      callback: () {
        Navigator.pushNamed(context, '/msg/sys');
      },
    ));
    _list.add(Container());
    getContacts();
  }

  getContacts() async {
    RResponse rResponse = await MessageService.listContacts();
    if (rResponse.code == 1) {
      _list.removeRange(2, _list.length);
      this.setState(() {
        for (var item in rResponse.data['contacts']) {
          _list.add(_ListItem(
            cover: item['cover'],
            title: item['contact_name'],
            subtitle: item['content_type'] == 0 ? item['content'] : "",
            callback: () {
              Navigator.pushNamed(context, '/msg/chat', arguments: {
                "id": item['contact_id'],
                "contact_name": item['contact_name']
              });
            },
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //getContacts();
    return Scaffold(
        appBar: AppBar(
          title: Text("消息列表"),
          backgroundColor: Colors.orange.withOpacity(0.6),
          actions: [
            Icon(
              Icons.more_vert,
              size: 30,
            ),
            SizedBox(
              width: 10,
            )
          ],
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
  String cover;
  dynamic callback;
  _ListItem(
      {Key? key,
      required this.cover,
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
            leading: ClipOval(
              child: CachedNetworkImage(
                  imageUrl: cover,
                  width: transferWidth(60),
                  height: transferlength(60),
                  fit: BoxFit.cover),
              // Image.network(
              //   cover,
              //   fit: BoxFit.cover,
              //   width: transferWidth(60),
              //   height: transferlength(60),
              // ),
            ),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                subtitle,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
