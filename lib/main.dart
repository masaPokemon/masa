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
      title: 'QR Code Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QRCodeScanner(),
    );
  }
}

class QRCodeScanner extends StatefulWidget {
  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  int _points = 0;
  int text = "";

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _points = prefs.getInt('points') ?? 0;
    });
  }

  Future<void> _savePoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('points', _points);
  }

  void _onQRViewCreated(String code) {
    setState(() {
      
      if (text != code.length) {
        text = code.length;
        if (code.contains('-')) {
          _points -= code.length;  // QRコードの文字の長さをポイントに減算
          _savePoints();           // ポイントを保存
        }else{
          _points += code.length;  // QRコードの文字の長さをポイントに加算
          _savePoints();           // ポイントを保存
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final Barcode barcode in barcodes) {
                  _onQRViewCreated(barcode.rawValue!);
                }
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('現在のポイント: $_points'),
          ),
        ],
      ),
    );
  }
}
