import 'package:flutter/material.dart';

import 'new.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListState();
  }
}

class ListState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    int _counter = 0;
    List<String> titleList = [
      "俺ガイル最終回",
      "ごちうさ1"
          "話",
      "SAO２３話",
      "冴えカノ映画fine",
      "彼女お借りします最終回",
      "化物語",
      "終物語"
    ];
    void _incrementCounter() {
      setState(() {
        _counter++;
      });
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('聖地ぶらり日記'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Pressed Action
              },
            ),
            PopupMenuButton<Choice>(
              onSelected: (Choice choice) {
                // Selected Action
              },
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ),
          ],
          backgroundColor: Colors.amber,
        ),
        body: ListView.builder(
            itemCount: titleList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.assistant_photo_outlined),
                    title: Text(titleList[index]),
                    subtitle: Text("2020/10/01"),
                    onTap: () {},
                  ),
                  Divider()
                ],
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                builder: (context) {
              return FormSubmitPage();
               }
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepOrange,
        ),
      )
    );
  }
}


//
class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '記事一覧', icon: Icons.settings),
  const Choice(title: '画像一覧', icon: Icons.my_location),
  const Choice(title: 'テーマ', icon: Icons.my_location),
];
