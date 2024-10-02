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
              setState(() {
                _pointsManager.loadPoints();
                _pointsManager.addPoints(10);
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

