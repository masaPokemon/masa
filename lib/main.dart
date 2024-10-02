import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PointsManager {
  int _points = 0;

  // 初期化
  Future<void> loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _points = prefs.getInt('points') ?? 0;
  }

  // ポイントを追加
  void addPoints(int points) {
    _points += points;
    _savePoints();
  }

  // ポイントを削除
  void removePoints(int points) {
    _points -= points;
    _savePoints();
  }

  // ポイントを保存
  Future<void> _savePoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('points', _points);
  }

  // 現在のポイントを取得
  int get points => _points;
}

class QRCodeScanner extends StatefulWidget {
  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  MobileScannerController cameraController = MobileScannerController();
  PointsManager pointsManager = PointsManager();

  @override
  void initState() {
    super.initState();
    pointsManager.loadPoints(); // 初期化
  }

  void _onQRCodeRead(String code) {
    int points = int.tryParse(code) ?? 0;
    if (points > 0) {
      pointsManager.addPoints(points); // ポイント追加
    } else {
      pointsManager.removePoints(-points); // ポイント削除（マイナス値）
    }
    setState(() {}); // UIの更新
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QRコードスキャナー')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (barcode, args) {
                _onQRCodeRead(barcode.rawValue);
              },
            ),
          ),
          Text('現在のポイント: ${pointsManager.points}'),
        ],
      ),
    );
  }
}

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
      home: QRCodeScanner(),
    );
  }
}
