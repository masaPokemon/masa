import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(home: MyHome()));
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _points = 0;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  // SharedPreferencesからポイントを読み込む
  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = prefs.getInt('points') ?? 0;
    });
  }

  // SharedPreferencesにポイントを保存する
  Future<void> _savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('points', _points);
  }

  // QRコードを検出したときの処理
  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return; // 連続スキャンを防止

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? rawValue = barcode.rawValue;
      if (rawValue != null) {
        debugPrint('Barcode found! $rawValue');
        _processScannedData(rawValue);
        break; // 最初の有効なバーコードのみ処理
      }
    }
  }

  // スキャンしたデータを処理し、ポイントを計算・保存
  void _processScannedData(String data) {
    setState(() {
      _isScanning = false; // スキャンを一時停止
      _points += data.length; // 文字列の長さをポイントとして加算
    });
    _savePoints();

    // ポップアップで結果を表示
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('スキャン完了'),
        content: Text('読み取った文字列: $data\n獲得ポイント: ${data.length}ポイント'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isScanning = true; // スキャンを再開
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ポイントをリセットする機能（必要に応じて）
  Future<void> _resetPoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('points', 0);
    setState(() {
      _points = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRコードスキャナー'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetPoints,
            tooltip: 'ポイントをリセット',
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            allowDuplicates: false,
            onDetect: _isScanning ? _onDetect : null,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.black54,
              child: Text(
                'ポイント: $_points',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(_isScanning ? Icons.pause : Icons.play_arrow),
        onPressed: () {
          setState(() {
            _isScanning = !_isScanning;
          });
        },
        tooltip: _isScanning ? 'スキャンを停止' : 'スキャンを開始',
      ),
    );
  }
}
