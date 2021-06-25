import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do app with shared_preferences',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'To do list'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _items = [];
  String _inputValue = '';

  void _addItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _items.add(_inputValue);
      prefs.setStringList('itemList', _items);
    });
  }

  void _deleteItem(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      int index = _items.indexOf(name);
      _items.removeAt(index);
      prefs.setStringList('itemList', _items);
    });
  }

  void _displayItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _items = prefs.getStringList('itemList') ?? [];
    });
  }

  Widget item(String name) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Text(
              name,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () => _deleteItem(name),
              icon: Icon(
                Icons.delete,
                color: Colors.red[700],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _displayItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter the name here',
              ),
              onChanged: (value) => _inputValue = value,
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (value) {
                if (value != '') _addItem();
              },
            ),
            ListView(
              shrinkWrap: true,
              children: _items.reversed.map((e) => item(e)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
