library easy_rich_text;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Widget that renders a string with sub-string highlighting.
class EasyRichText extends StatelessWidget {
  EasyRichText({
    @required this.text,
    this.chars,
    this.context,
    this.fussy,
    this.textStyle = const TextStyle(
      color: Colors.black,
    ),
    this.textStyleHighlight = const TextStyle(
      color: Colors.red,
    ),
  });

  // pass in pattern
  // pass-through if no matches
  final bool fussy;

  final String chars;

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
    if (text == null) {
      return Text('');
    } else if (text.isEmpty) {
      return Text(text);
    } else {
      print('text: $text');
      List<InlineSpan> children = [];

      Set set = Set();

      // parse into array
      List<String> spanList = text.split(RegExp(chars ?? r"[*~/_\\]"));
      print("len=${spanList.length}: $spanList");

      int i = 0;
      bool acceptNext = true;
      String route;

      void wrap(String v) {
        print("wrap: $v set=$set");
        TextStyle ts = TextStyle(
            decoration: set.contains('_')
                ? TextDecoration.underline
                : TextDecoration.none,
            fontStyle: set.contains('/') ? FontStyle.italic : FontStyle.normal,
            fontWeight:
                set.contains('*') ? FontWeight.bold : FontWeight.normal);
        children.add(TextSpan(text: v, style: ts));
      }

      void toggle(String m) {
        if (m == r'\') {
          String c = text.substring(i + 1, i + 2);
          print("quote: i=$i: $c");
          wrap(c);
          acceptNext = false;
        } else {
          if (acceptNext) {
            if (set.contains(m)) {
              print("REM: $m");
              set.remove(m);
            } else {
              print("ADD: $m");
              set.add(m);
            }
          }

          acceptNext = true;
        }
      }

      for (var v in spanList) {
        print("========== $v ==========");
        if (v.isEmpty) {
          if (i < text.length) {
            String m = text.substring(i, i + 1);
//          print("e: $m");
            toggle(m);
            i++;
          }
        } else {
          int adv = v.length;
          if (v[0] == '{') {
            print("check $v");
            int close = v.indexOf('}');
            if (close > 0) {
              String param = v.substring(1, close);
              print("param2=$param");
              route = param;
//                  Navigator.pushNamed(context, param);
              v = v.substring(close + 1);
              print("remaining: $v");
            }
          }
          wrap(v);
          i += adv;
          if (i < text.length) {
            String m = text.substring(i, i + 1);
            print("*** format: $m");
            toggle(m);
            i++;
          }
        }
      }

      if (fussy ?? false && set.isNotEmpty) {
        throw 'easy_rich_text: not closed: $set'; //TODO: throw real error?
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
