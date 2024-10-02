
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(MyApp());
}

class ScannerWidget extends StatefulWidget {
  const ScannerWidget({super.key});

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget>
    with SingleTickerProviderStateMixin {
  MobileScannerController controller = MobileScannerController();
  final PointsManager _pointsManager = PointsManager();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF66FF99),
        title: const Text('スキャンしよう'),
      ),
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return MobileScanner(
            controller: controller,
            fit: BoxFit.contain,
            onDetect: (scandata) {
              _pointsManager.addPoints(10);
              setState(() {
                controller.stop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return MyApp();
                    },
                  ),
                );
              });
            },
          );
        },
      ),
    );
  }
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ポイントシステム',
      home: PointsPage(),
    );
  }
}

class PointsPage extends StatefulWidget {
  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  final PointsManager _pointsManager = PointsManager();

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  // ポイントをロード
  Future<void> _loadPoints() async {
    await _pointsManager.loadPoints();
    setState(() {});
  }

  // UIの構築
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
              '現在のポイント: ${_pointsManager.points}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ScannerWidget(),
                    ),
                  );
                });
              },
              child: Text('ポイントを計算'),
            ),
          ],
        ),
      ),
    );
  }
}


class PointsManager {
  int _points = 0;

  // ポイントを取得
  int get points => _points;

  // ポイントを加算
  void addPoints(int value) {
    _points += value;
    _savePoints();
  }

  // ポイントを減算
  void subtractPoints(int value) {
    _points -= value;
    _savePoints();
  }

  // ポイントを保存
  Future<void> _savePoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('points', _points);
  }

  // ポイントをロード
  Future<void> loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _points = prefs.getInt('points') ?? 0; // デフォルトは0
  }
}
