import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp1 extends StatelessWidget {
  const MyApp1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: My1HomePage(),
    );
  }
}

class My1HomePage extends StatefulWidget {
  const My1HomePage({Key? key}) : super(key: key);

  @override
  State<My1HomePage> createState() => _My1HomePageState();
}

class _My1HomePageState extends State<My1HomePage> {
  String scannedValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo QR Code Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 600,
              child: MobileScanner(
                controller: MobileScannerController(
                  detectionSpeed:
                      DetectionSpeed.noDuplicates, // 同じ QR コードを連続でスキャンさせない
                ),
                onDetect: (capture) {
                  // QR コード検出時の処理
                  final List<Barcode> barcodes = capture.barcodes;
                  final value = barcodes[0].rawValue;
                  if (value != null) {
                    // 検出した QR コードの値でデータを更新
                    setState(() {
                      _addPoints(value)
                    });
                    Navigator.pop(context);;
                  }
                },
              ),
            ),
            Text(
              scannedValue == '' ? 'QR コードをスキャンしてください。' : 'QRコードを検知しました。',
              style: const TextStyle(fontSize: 15),
            ),
            // QR コードの値を表示
            Text(scannedValue == '' ? "" : "value: $scannedValue"),
          ],
        ),
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
      title: 'ポイント管理アプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PointManager(),
    );
  }
}
// ポイントをロードする
Future<void> _loadPoints() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _points = prefs.getInt(_prefsKey) ?? 0;
  });
}

// ポイントを保存する
Future<void> _savePoints() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_prefsKey, _points);
}

// ポイントを追加する
void _addPoints(int value) {
  setState(() {
    _points += value;
  });
  _savePoints();
}

// ポイントを削除する
void _removePoints(int value) {
  setState(() {
    _points = (_points - value < 0) ? 0 : _points - value;
  });
  _savePoints();
}

class PointManager extends StatefulWidget {
  @override
  _PointManagerState createState() => _PointManagerState();
}

class _PointManagerState extends State<PointManager> {
  int _points = 0;
  final _prefsKey = 'points';

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  

  // QRコードスキャン時の処理
  void _onQRCodeScanned(String code) {
    int value = int.tryParse(code) ?? 0;
    if (value != 0) {
      if (value > 0) {
        _addPoints(value);
      } else {
        _removePoints(-value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ポイント管理アプリ'),
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
            onPressed: () => _addPoints(10),
            child: Text('10ポイント追加'),
          ),
          ElevatedButton(
            onPressed: () => _removePoints(10),
            child: Text('10ポイント削除'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyApp1(),
                ),
              );
            },
            child: Text('QRコードでポイントを追加/削除'),
          ),
        ],
      ),
    );
  }
}

class QRCodeScanner extends StatelessWidget {
  final Function(String) onScanned;

  QRCodeScanner({required this.onScanned});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QRコードスキャン'),
      ),
      body: MobileScanner(
        onDetect: (scandata) {
          if (scandata.rawValue != null) {
            final String code = scandata.rawValue!;
            onScanned(code);
            Navigator.pop(context); // スキャン後に前の画面に戻る
          }
        },
      ),
    );
  }
}
