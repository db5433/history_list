import 'package:flutter/material.dart';
import 'package:history_list/history_list.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List messageList = [
    {'index': 0, 'message': '新数据', 'type': 'Left'},
    {'index': 1, 'message': '新数据', 'type': 'Left'},
    {'index': 2, 'message': '新数据', 'type': 'Left'},
    {'index': 3, 'message': '新数据', 'type': 'Left'},
    {'index': 4, 'message': '新数据', 'type': 'Left'},
    {'index': 5, 'message': '新数据', 'type': 'Left'},
    {'index': 6, 'message': '新数据', 'type': 'Left'},
    {'index': 7, 'message': '新数据', 'type': 'Left'},
    {'index': 8, 'message': '新数据', 'type': 'Left'},
    {'index': 9, 'message': '新数据', 'type': 'Left'},
    {'index': 10, 'message': '新数据', 'type': 'Left'}
  ];

  List oldMessageList = [];

  addMessage() {
    messageList
        .add({'index': messageList.length, 'message': '新数据', 'type': 'Right'});
    setState(() {});
  }

  addOldMessage() {
    oldMessageList.add(
        {'index': oldMessageList.length, 'message': '旧数据', 'type': 'Right'});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('专属客服'),
          actions: [
            IconButton(
                color: Colors.white,
                onPressed: () {
                  addOldMessage();
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.red,
                )),
            IconButton(
                onPressed: () {
                  addMessage();
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.green,
                ))
          ],
        ),
        body: Stack(
          children: [
            HistoryMessageList(
              newBuilder: (p0, p1) {
                var item = messageList[p1];
                if (item['type'] == "Right") {
                  return newRightItem(item);
                } else {
                  return newRightItem(item);
                }
              },
              oldBuilder: (p0, p1) {
                var item = oldMessageList[p1];
                if (item['type'] == "Right") {
                  return rightItem(item);
                } else {
                  return rightItem(item);
                }
              },
              newHardle: (() {
                return Future.delayed(Duration(seconds: 2), () {
                  addMessage();
                });
              }),
              oldHardle: (() {
                return Future.delayed(Duration(seconds: 2), () {
                  addOldMessage();
                });
              }),
              oldCount: oldMessageList.length,
              newCount: messageList.length,
              oldloadingWidget: Padding(
                padding: EdgeInsets.all(20),
                child: Text('获取更多历史消息'),
              ),
            ),
          ],
        ));
  }

  rightItem(item) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 80,
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Text(item['index'].toString()), Text(item['message'])],
      ),
    );
  }

  newRightItem(item) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: SizedBox(
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: const Icon(Icons.account_circle),
          title: Text(item['message']),
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
