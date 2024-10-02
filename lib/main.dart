import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('pointsBox'); // ポイントデータを保存するためのBoxを開く
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ポイントシステム',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Box pointsBox = Hive.box('pointsBox');
  int points = 0;

  @override
  void initState() {
    super.initState();
    points = pointsBox.get('points', defaultValue: 0);
  }

  void addPoints(int amount) {
    setState(() {
      points += amount;
      pointsBox.put('points', points);
    });
  }

  void removePoints(int amount) {
    setState(() {
      points -= amount;
      pointsBox.put('points', points);
    });
  }

  void scanQRCode() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: MobileScanner(
              onDetect: (barcode, args) {
                addPoints(100);
                final String code = barcode.rawValue ?? '';
                Navigator.of(context).pop();
                // QRコードの値を整数に変換し、ポイントを追加または削除する
                int value = int.tryParse(code) ?? 0;
                if (value > 0) {
                  addPoints(value);
                } else if (value < 0) {
                  removePoints(-value); // 負の値で削除
                }
              },
            ),
          ),
        );
      },
    );
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
          children: [
            Text('現在のポイント: $points'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanQRCode,
              child: Text('QRコードをスキャン'),
            ),
          ],
        ),
      ),
    );
  }
}
