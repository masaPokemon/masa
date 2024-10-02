import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: const PointsPage(),
    );
  }
}

class PointsPage extends StatefulWidget {
  const PointsPage({Key? key}) : super(key: key);

  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  int _points = 0;

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
    prefs.setInt('points', _points);
  }

  void _updatePoints(int value) {
    setState(() {
      _points += value;
      _savePoints();
    });
  }

  void _scanQRCode() async {
    String? scannedValue = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QRCodeScanner(),
      ),
    );

    if (scannedValue != null) {
      int value = int.tryParse(scannedValue) ?? 0;
      _updatePoints(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ポイントシステム'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '現在のポイント: $_points',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scanQRCode,
              child: const Text('QRコードをスキャン'),
            ),
          ],
        ),
      ),
    );
  }
}

class QRCodeScanner extends StatelessWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      onDetect: (barcode, args) {
        if (barcode.rawValue != null) {
          Navigator.of(context).pop(barcode.rawValue);
        }
      },
    );
  }
}
