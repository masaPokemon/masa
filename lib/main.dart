import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/services.dart';
import 'package:bluetooth_info/bluetooth_info.dart';

void main() {
  runApp(MaterialApp(
    home: BluetoothInfoExample(),
  ));
}

class BluetoothInfoExample extends StatefulWidget {
  const BluetoothInfoExample({super.key});

  @override
  State<BluetoothInfoExample> createState() => _BluetoothInfoExampleState();
}

class _BluetoothInfoExampleState extends State<BluetoothInfoExample> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 1000), () async {
        await isBTPermissionGiven();
      });
    });
    super.initState();
  }

  Future<bool> isBTPermissionGiven() async {
    if (Platform.isIOS) {
      if (!await Permission.bluetooth.isRestricted) {
        return true;
      } else {
        var response = await [Permission.bluetooth].request();
        return response[Permission.bluetooth]?.isGranted == true;
      }
    } else if (Platform.isAndroid) {
      var isAndroidS = (int.tryParse(
                  (await DeviceInfoPlugin().androidInfo).version.release) ??
              0) >=
          11;
      if (isAndroidS) {
        if (await Permission.bluetoothScan.isGranted) {
          return true;
        } else {
          var response = await [
            Permission.bluetoothScan,
            Permission.bluetoothConnect
          ].request();
          return response[Permission.bluetoothScan]?.isGranted == true &&
              response[Permission.bluetoothConnect]?.isGranted == true;
        }
      } else {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bluetooth Info Example')),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _getDeviceName(),
                child: Text('Get Device Name'),
              ),
              ElevatedButton(
                onPressed: () => _getDeviceAddress(),
                child: Text('Get Device Address'),
              ),
              ElevatedButton(
                onPressed: () => _checkBluetoothStatus(),
                child: Text('Check Bluetooth Status'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getDeviceName() async {
    String deviceName = await BluetoothInfo.getDeviceName();
    print('Device Name: $deviceName');
  }

  void _getDeviceAddress() async {
    String deviceAddress = await BluetoothInfo.getDeviceAddress();
    print('Device Address: $deviceAddress');
  }

  void _checkBluetoothStatus() async {
    bool isBluetoothEnabled = await BluetoothInfo.isBluetoothEnabled();
    print('Bluetooth Enabled: $isBluetoothEnabled');
  }
}
