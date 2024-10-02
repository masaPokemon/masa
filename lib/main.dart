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
      title: 'ポイントシステム',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PointScreen(),
    );
  }
}

class PointScreen extends StatefulWidget {
  @override
  _PointScreenState createState() => _PointScreenState();
}

class _PointScreenState extends State<PointScreen> {
  int _points = 0;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  // ポイントをロードする
  void _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = prefs.getInt('points') ?? 0;
    });
  }

  // ポイントを保存する
  void _savePoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('points', _points);
  }

  // ポイントを追加・削除する
  void _updatePoints(int value) {
    setState(() {
      _points += value;
      if (_points < 0) _points = 0; // ポイントがマイナスにならないようにする
    });
    _savePoints();
  }

  // QRコードを読み取った際の処理
  void _onQRCodeScanned(String value) {
    int scannedValue = int.tryParse(value) ?? 0;
    _updatePoints(scannedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ポイントシステム'),
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
                MaterialPageRoute(
                  builder: (context) => QRScannerScreen(
                    onQRCodeScanned: _onQRCodeScanned,
                  ),
                ),
              );
            },
            child: Text('QRコードをスキャン'),
          ),
        ],
      ),
    );
  }
}

class QRScannerScreen extends StatelessWidget {
  final Function(String) onQRCodeScanned;

  QRScannerScreen({required this.onQRCodeScanned});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QRコードスキャナー'),
      ),
      body: MobileScanner(
        onDetect: (barcode, args) {
          if (barcode.rawValue != null) {
            final String code = barcode.rawValue!;
            onQRCodeScanned(code);
            Navigator.pop(context);  // スキャン完了後、前の画面に戻る
          }
        },
      ),
    );
  }
}
