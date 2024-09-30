import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ポイントシステム',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PointSystemPage(),
    );
  }
}

class PointSystemPage extends StatefulWidget {
  @override
  _PointSystemPageState createState() => _PointSystemPageState();
}

class _PointSystemPageState extends State<PointSystemPage> {
  int _points = 0;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  // ポイントをロード
  _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = prefs.getInt('points') ?? 0;
    });
  }

  // ポイントを保存
  _savePoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('points', _points);
  }

  // ポイントを加算
  void _addPoints() {
    setState(() {
      _points += 10;
    });
    _savePoints();
  }

  // ポイントを減算
  void _subtractPoints() {
    setState(() {
      _points = _points > 0 ? _points - 10 : 0;
    });
    _savePoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ポイントシステム'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '現在のポイント:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$_points',
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addPoints,
                  child: Text('ポイントを追加'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _subtractPoints,
                  child: Text('ポイントを減算'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
