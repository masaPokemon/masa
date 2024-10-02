import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ポイント管理アプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PointManager(),
    );
  }
}

class PointManager extends StatefulWidget {
  @override
  _PointManagerState createState() => _PointManagerState();
}

class _PointManagerState extends State<PointManager> {
  int _points = 0;
  final _prefsKey = 'points';

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  // ポイントをロードする
  Future<void> _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = prefs.getInt(_prefsKey) ?? 0;
    });
  }

  // ポイントを保存する
  Future<void> _savePoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, _points);
  }

  // ポイントを追加する
  void _addPoints(int value) {
    setState(() {
      _points += value;
    });
    _savePoints();
  }

  // ポイントを削除する
  void _removePoints(int value) {
    setState(() {
      _points = (_points - value < 0) ? 0 : _points - value;
    });
    _savePoints();
  }

  // QRコードスキャン時の処理
  void _onQRCodeScanned(String code) {
    int value = int.tryParse(code) ?? 0;
    if (value != 0) {
      if (value > 0) {
        _addPoints(value);
      } else {
        _removePoints(-value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ポイント管理アプリ'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '現在のポイント: $_points',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _addPoints(10),
            child: Text('10ポイント追加'),
          ),
          ElevatedButton(
            onPressed: () => _removePoints(10),
            child: Text('10ポイント削除'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRCodeScanner(onScanned: _onQRCodeScanned),
                ),
              );
            },
            child: Text('QRコードでポイントを追加/削除'),
          ),
        ],
      ),
    );
  }
}

class QRCodeScanner extends StatelessWidget {
  final Function(String) onScanned;

  QRCodeScanner({required this.onScanned});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QRコードスキャン'),
      ),
      body: MobileScanner(
        onDetect: (scandata) {
          if (scandata.rawValue != null) {
            final String code = scandata.rawValue!;
            onScanned(code);
            Navigator.pop(context); // スキャン後に前の画面に戻る
          }
        },
      ),
    );
  }
}
