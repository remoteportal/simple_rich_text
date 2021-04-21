import 'package:flutter/material.dart';
import 'package:simple_rich_text/simple_rich_text.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    String text = null;
//    String text = 'no format characters';
//    String text = r'format characters: \*\/\_';
//    String text = '_entire string_';
//    String text = '*/_fully loaded!_*/';
//    String text = 'first *bold*.';
//    String text = r'test*\_quoted\_*.';
//    String text = r'don't*close';
//    String text = r'_start at beginning and do not close';
//    String text = r'/Alissa/ is /awesome/!';
//    String text = r'_back__to back_';
//    String text = r'go to _{route}home_ page';
    //String text = '*_/this is all three*_/ (*{color:red}bold*, _underlined_, and /{color:brown}italicized/). _{push:home;color:blue}clickable hyperlink to home screen_';
    //String text = r'This is a text with \nnew line';
    String text =
        r'Now you can change the ~{fontSize:32}size~ of the text. \nInsert a new line.\nChange the ~{backgroundColor:yellow}background color~\nAnd modify more style as: fontFamily, _{decorationColor:blue}decorationColor_, ~{height:3}height~, etc\n\nToo you can open url: _{http:www.google.com;color:blue}go to Google_\nFinaly, you can define textAlign, maxLines and textOverflow';
    return new MaterialApp(
      home: Scaffold(
        // , chars: r"[*]"
//          backgroundColor: Colors.grey[300],
        body: Center(
          child: SimpleRichText(
            text,
            style: TextStyle(color: Colors.orange),
            maxLines: 20,
            textAlign: TextAlign.center,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
