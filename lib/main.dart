import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaterialApp(home: MyHome()));

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  MyHomeState createState() => MyHomeState();
}
class _MyHomeState extends State<MyHome> {
  
  int _points = 0;

  @override
  void initState() {
    super.initState();
    _loadPoints(); // 起動時にポイントをロード
  }

  // ポイントを保存する関数
  Future<void> _savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('points', _points);
  }

  // ポイントをロードする関数
  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = prefs.getInt('points') ?? 0;
    });
  }

  // ポイントを加算する関数
  void _addPoints(int length) {
    setState(() {
      _points += length;
    });
    _savePoints(); // ポイントを保存
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Scanner')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final String? rawValue = barcode.rawValue;
                  if (rawValue != null) {
                    debugPrint('Barcode found! $rawValue');
                    _addPoints(rawValue.length); // 読み取った文字の長さでポイントを加算
                  }
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Current Points: $_points',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class MyHomeState extends State<MyHome> {
  int _points = 0;

  @override
  void initState() {
    super.initState();
    _loadPoints(); // 起動時にポイントをロード
  }

  // ポイントを保存する関数
  Future<void> _savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('points', _points);
  }

  // ポイントをロードする関数
  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = prefs.getInt('points') ?? 0;
    });
  }

  // ポイントを加算する関数
  void _addPoints(int length) {
    setState(() {
      _points += length;
    });
    _savePoints(); // ポイントを保存
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Scanner')),
      body: Column(
        children: [
          ElevatedButton(
          // 押したらスキャンの画面に入るボタン
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const _MyHomeState(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 20, // ボタンが画面から浮かぶ高さ（影で現す）
            fixedSize: const Size.fromHeight(300), // ボタンの大きさ
            backgroundColor: const Color(0xFFAADDCC), // ボタンの背景の色
            side:
                const BorderSide(color: Color(0xFF44AA66), width: 6), // ボタンの枠線
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner_sharp, // QRスキャンのアイコン
                size: 120,
              ),
              Text(
                'スキャンを始める',
                style: TextStyle(fontSize: 36),
              )
            ],
          ),
        ],
      ),
    );
  }
}
