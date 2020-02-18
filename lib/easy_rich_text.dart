library easy_rich_text;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Widget that renders a string with sub-string highlighting.
class EasyRichText extends StatelessWidget {
  EasyRichText({
    @required this.text,
    this.context,
    this.textStyle = const TextStyle(
      color: Colors.black,
    ),
    this.textStyleHighlight = const TextStyle(
      color: Colors.red,
    ),
  });

  /// The String to be displayed using rich text.
  final String text;

  /// For navigation
  final BuildContext context;

  /// The {TextStyle} of the {EasyRichText.text} that isn't highlighted.
  final TextStyle textStyle;

  /// The {TextStyle} of the {EasyRichText.term}s found.
  final TextStyle textStyleHighlight;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return Text(text);
    } else {
      print('text: $text');
      List<InlineSpan> children = [];

      Set set = Set();

      void toggle(String m) {
        if (set.contains(m)) {
          print("REM: $m");
          set.remove(m);
        } else {
          print("ADD: $m");
          set.add(m);
        }
      }

      // parse into array
      List<String> spanList = text.split(RegExp(r"[*~_]"));
      print("len=${spanList.length}");
      print("len=$spanList");

//      return Text(text);

      int i = 0;
      for (var v in spanList) {
        if (v.isEmpty) {
          print("e: ${text.substring(i, i + 1)}");
          i++;
        } else if (v.isNotEmpty) {
          print("wrap: $v ($set)");
//          print("wrap: ${text.substring(i, i + v.length)}");
          TextStyle ts = TextStyle(
              fontWeight:
                  set.contains('*') ? FontWeight.bold : FontWeight.normal);
          children
              .add(TextSpan(text: text.substring(i, i + v.length), style: ts));
          i += v.length;
          if (i < text.length) {
            String m = text.substring(i, i + 1);
//            print("format: $m");
            toggle(m);
            i++;
          }
        }
//        if (i < text.length) {
//          children.add(TextSpan(
//              text: text.substring(i, i + term.length),
//              style: textStyleHighlight));
//          i += term.length;
//        }
      }
      return RichText(text: TextSpan(children: children));
    }
  }
}

//  Widget build(BuildContext context) {
//    if (term.isEmpty) {
//      return Text(text, style: textStyle);
//    } else {
//      String termLC = term.toLowerCase();
//
//      List<InlineSpan> children = [];
//      List<String> spanList = text.toLowerCase().split(termLC);
//      int i = 0;
//      for (var v in spanList) {
//        if (v.isNotEmpty) {
//          children.add(TextSpan(
//              text: text.substring(i, i + v.length), style: textStyle));
//          i += v.length;
//        }
//        if (i < text.length) {
//          children.add(TextSpan(
//              text: text.substring(i, i + term.length),
//              style: textStyleHighlight));
//          i += term.length;
//        }
//      }
//      return RichText(text: TextSpan(children: children));
//    }
//  }
//}
