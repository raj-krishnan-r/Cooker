import 'dart:convert';
import 'dart:ffi';

import 'package:cooker/models/Item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 int _selectedIndex=0;
void _onItemTapped(int index){
  setState(() {
    _selectedIndex=index;
  });
}
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(key: UniqueKey(),
      body: BodyBuilder(selection: _selectedIndex,),
      appBar: AppBar(title: Text('Cookup'),),bottomNavigationBar: BottomNavigationBar(items: const<BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.list),label: 'List'),
        BottomNavigationBarItem(icon: Icon(Icons.batch_prediction),label: 'Predict'),
    ],currentIndex: _selectedIndex,selectedItemColor: Colors.brown,onTap: _onItemTapped,),
    );
  }
}

//class MyHomePage extends StatefulWidget {
class BodyBuilder extends StatefulWidget{
  BodyBuilder({Key key,this.selection}):super(key:key);
  final int selection;
  @override
  _BodyBuilder createState() => _BodyBuilder(selection: selection);
}
class _BodyBuilder extends State<BodyBuilder> {
  _BodyBuilder({this.selection});

  final int selection;

  @override
  Widget build(BuildContext context) {
    switch(selection){
      case 0:
        return Container(child: ItemsList(),);
        break;
      case 1:
        return Container(child: Predictions(),);
        break;
      default:
        return Container(child: ItemsList(),);
    }

  }
}

class ItemsList extends StatefulWidget{
  ItemsList({Key key}):super(key: key);
  @override
  _ItemsList createState() => _ItemsList();
}

class _ItemsList extends State<ItemsList>
{
  List<Item> list=[];

  @protected
  @mustCallSuper
void initState(){
fetchList();
}

List ListTiles(List<Item> items){
    List<ListTile> list=[];
    items.forEach((element) {
      list.add(ListTile(title: Text(element.title),));
    });
    return list;

}

Future<http.Response> fetchList() async{
  final response = (await http.get('https://jsonplaceholder.typicode.com/albums/'));
  List<dynamic> tokens = jsonDecode(response.body);
  List<Item> tempList=[];
  for(int a= 0;a<tokens.length;a++)
    {
      tempList.add(new Item(title: ((tokens.elementAt(a)['title'])).toString(),id: ((tokens.elementAt(a))['id']).toString()));
    }
  setState(() {
  list=tempList;
  });
}

  @override
  Widget build(BuildContext context)
  {
    return ListView(children: ListTiles(list),);
  }
}

class Predictions extends StatefulWidget{
  Predictions({Key key}):super(key: key);
  @override
  _Predictions createState() => _Predictions();
}
class _Predictions extends State<Predictions>
{
  @override
  Widget build(BuildContext context)
  {
    return Text('Predictions');
  }
}


