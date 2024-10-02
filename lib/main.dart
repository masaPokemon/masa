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
  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = prefs.getInt('points') ?? 0;
    });
  }

  // ポイントを保存する
  Future<void> _savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('points', _points);
  }

  // ポイントを追加
  void _addPoints(int points) {
    setState(() {
      _points += points;
      _savePoints();
    });
  }

  // ポイントを削除
  void _subtractPoints(int points) {
    setState(() {
      _points = (_points - points >= 0) ? _points - points : 0;
      _savePoints();
    });
  }

  // QRコードスキャン結果でポイントを追加/削除
  void _onQRCodeScanned(String code) {
    try {
      int scannedPoints = int.parse(code);
      if (scannedPoints > 0) {
        _addPoints(scannedPoints);
      } else if (scannedPoints < 0) {
        _subtractPoints(scannedPoints.abs());
      }
    } catch (e) {
      // QRコードの内容が数字でない場合のエラーハンドリング
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QRコードが無効です')),
      );
    }
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
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRCodeScanner(onScan: _onQRCodeScanned)),
                );
              },
              child: Text('QRコードをスキャン'),
            ),
          ],
        ),
      ),
    );
  }
}

class QRCodeScanner extends StatelessWidget {
  final Function(String) onScan;

  QRCodeScanner({required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QRコードスキャナ'),
      ),
      body: MobileScanner(
        onDetect: (barcode, args) {
          if (barcode.rawValue != null) {
            final String code = barcode.rawValue!;
            onScan(code);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
