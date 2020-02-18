import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    String text = 'first*bold*.';
    String text = 'first*_bold_*.';
    return new MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.grey,
          body: Center(child: EasyRichText(text: text))),
    );
  }
}
