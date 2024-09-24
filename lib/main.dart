import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
 
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: MyApp()));
}
 
class MyApp extends StatefulWidget {
  const MyApp({super.key});
 
  @override
  State<MyApp> createState() => _MyAppState();
}
 
class _MyAppState extends State<MyApp> {
  final GlobalKey webViewKey = GlobalKey();
 
  InAppWebViewController? webViewController;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mochoto InAppWebView")),
      body: SafeArea(
          child: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(url: WebUri("https://inappwebview.dev/")),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
      )),
    );
  }
}
 
