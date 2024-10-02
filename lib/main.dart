import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ポイントシステム',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PointScreen(),
    );
  }
}

class PointScreen extends StatefulWidget {
  const PointScreen({Key? key}) : super(key: key);

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
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = prefs.getInt('points') ?? 0;
    });
  }

  // ポイントを保存する
  void _savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('points', _points);
  }

  // ポイントを増減させる
  void _updatePoints(int change) {
    setState(() {
      _points += change;
      if (_points < 0) {
        _points = 0;
      }
    });
    _savePoints();
  }

  // QRコードを読み取り、ポイントを追加/削除
  void _onQRCodeScanned(String code) {
    int? value = int.tryParse(code);
    if (value != null) {
      _updatePoints(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ポイント管理システム'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('現在のポイント: $_points', style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRScanner(onScanned: _onQRCodeScanned)),
              );
            },
            child: const Text('QRコードでポイントを変更'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _points = 0;
            _savePoints();
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class QRScanner extends StatelessWidget {
  final Function(String) onScanned;

  const QRScanner({Key? key, required this.onScanned}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRコードスキャン'),
      ),
      body: MobileScanner(
        onDetect: (barcode, args) {
          final String code = barcode.rawValue!;
          onScanned(code);
          Navigator.pop(context);
        }
      ),
    );
  }
}
