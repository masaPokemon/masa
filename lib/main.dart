import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
  int points = 0;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  // ポイントを読み込む
  Future<void> _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      points = (prefs.getInt('points') ?? 0);
    });
  }

  // ポイントを保存する
  Future<void> _savePoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('points', points);
  }

  // QRコードをスキャンしたときの処理
  void _handleQRCode(String code) {
    int value = int.tryParse(code) ?? 0;
    setState(() {
      points += value; // ポイントを追加
    });
    _savePoints();
  }

  // ポイントを減らす処理
  void _subtractPoints() {
    setState(() {
      points -= 1; // 例として1ポイント減らす
    });
    _savePoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ポイント: $points'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '現在のポイント: $points',
            style: TextStyle(fontSize: 24),
          ),
          ElevatedButton(
            onPressed: _subtractPoints,
            child: Text('ポイントを1減らす'),
          ),
          Expanded(
            child: MobileScanner(
              onDetect: (barcode, args) {
                final String code = barcode.rawValue ?? '';
                _handleQRCode(code);
              },
            ),
          ),
        ],
      ),
    );
  }
}
