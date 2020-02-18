import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home:
          Scaffold(body: Center(child: EasyRichText(text: 'This is *bold*.'))),
    );
  }
}
