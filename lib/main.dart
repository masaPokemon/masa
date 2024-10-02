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
      title: 'ポイント管理システム',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PointPage(),
    );
  }
}

class PointPage extends StatefulWidget {
  @override
  _PointPageState createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  int _points = 0;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  // ポイントの読み込み
  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = prefs.getInt('points') ?? 0;
    });
  }

  // ポイントの保存
  Future<void> _savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('points', _points);
  }

  // ポイントを追加
  void _addPoints(int value) {
    setState(() {
      _points += value;
    });
    _savePoints();
  }

  // ポイントを削除
  void _removePoints(int value) {
    setState(() {
      _points -= value;
    });
    _savePoints();
  }

  // QRコードを読み取ってポイントを追加または削除
  void _onQRViewCreated(String data) {
    int? value = int.tryParse(data); // QRコードから取得した値を整数に変換
    if (value != null) {
      if (value > 0) {
        _addPoints(value);  // ポイントを追加
      } else {
        _removePoints(-value);  // ポイントを削除
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ポイント管理システム'),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRScannerPage(onQRViewCreated: _onQRViewCreated)),
              );
            },
            child: Text('QRコードでポイントを追加/削除'),
          ),
        ],
      ),
    );
  }
}

class QRScannerPage extends StatelessWidget {
  final Function(String) onQRViewCreated;

  QRScannerPage({required this.onQRViewCreated});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QRコードをスキャン')),
      body: MobileScanner(
        onDetect: (barcode, args) {
          final String code = barcode.rawValue ?? '';
          onQRViewCreated(code);
          Navigator.pop(context);  // スキャン後、元の画面に戻る
        },
      ),
    );
  }
}
