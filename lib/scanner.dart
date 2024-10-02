import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'scandata.dart';
import 'main.dart';

class ScannerWidget extends StatefulWidget {
  const ScannerWidget({super.key});

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget>
    with SingleTickerProviderStateMixin {
  // スキャナーの作用を制御するコントローラーのオブジェクト
  MobileScannerController controller = MobileScannerController();
  bool isStarted = true; // カメラがオンしているかどうか
  double zoomFactor = 0.0; // ズームの程度。0から1まで。多いほど近い
  final PointsManager _pointsManager = PointsManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF66FF99), // 上の部分の背景色
        title: const Text('スキャンしよう'),
      ),
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // カメラの画面の部分
              SizedBox(
                height: MediaQuery.of(context).size.width * 4 / 3,
                child: MobileScanner(
                  controller: controller,
                  fit: BoxFit.contain,
                  // QRコードかバーコードが見つかった後すぐ実行する関数
                  onDetect: (scandata) {
                    setState(() {
                      _pointsManager.addPoints(scandata as int);
                      controller.stop(); // まずはカメラを止める
                      // 結果を表す画面に切り替える
                      MyApp();
                    });
                  },
                ),
              ),
              // ズームを調整するスライダー
            ],
          );
        },
      ),
    );
  }
}

