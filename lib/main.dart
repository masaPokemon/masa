import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRコードスキャナー',
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
  MobileScannerController cameraController = MobileScannerController();
  int points = 0;

  void onDetect(MobileScannerCapture capture) {
    final String? code = capture.barcodes.first.rawValue;
    if (code != null) {
      // QRコードの内容に応じてポイントを加算
      setState(() {
        points += 10; // 例えば、各QRコードに対して10ポイントを加算
      });
      // スキャン結果を表示
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('QRコードが検出されました'),
            content: Text('コード: $code\nポイント: $points'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QRコードスキャナー'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: onDetect,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('獲得ポイント: $points', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }
}
