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
      home: PointSystem(),
    );
  }
}

class PointSystem extends StatefulWidget {
  @override
  _PointSystemState createState() => _PointSystemState();
}

class _PointSystemState extends State<PointSystem> {
  int _points = 0;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  // ポイントをロードする関数
  void _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = prefs.getInt('points') ?? 0;
    });
  }

  // ポイントを保存する関数
  void _savePoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('points', _points);
  }

  // ポイントを加算する関数
  void _incrementPoints() {
    setState(() {
      _points++;
    });
    _savePoints();
  }

  // ポイントを減算する関数
  void _decrementPoints() {
    setState(() {
      _points--;
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
            ),
            Text(
              '$_points',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _incrementPoints,
                  child: Text('ポイント加算'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _decrementPoints,
                  child: Text('ポイント減算'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
