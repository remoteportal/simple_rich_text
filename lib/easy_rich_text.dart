library easy_rich_text;

import 'package:flutter/gestures.dart';
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

      // split into array
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
//        TextSpan span = TextSpan(text: v, style: ts);
        if (route != null) {
//          GestureDetector
//        children.add(WidgetSpan(child: Text('****')));
//          children.add(WidgetSpan(
//              child: GestureDetector(
//            child: Text('CLICK'),
//            onTap: () async {
//              print("TAPPED");
//            },
//          )));
          children.add(TextSpan(
              text: v,
//              text: 'TAP',
              // Beware!  This class is only safe because the TapGestureRecognizer is not given a deadline and therefore never allocates any resources.
              // In any other situation -- setting a deadline, using any of the less trivial recognizers, etc -- you would have to manage the gesture recognizer's lifetime
              // and call dispose() when the TextSpan was no longer being rendered.
              // Since TextSpan itself is @immutable, this means that you would have to manage the recognizer from outside
              // the TextSpan, e.g. in the State of a stateful widget that then hands the recognizer to the TextSpan.
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print("TAP");
                  Navigator.pushNamed(context, '/${route}');
                },
              style: ts));
          route = null;
        } else {
//          children.add(span);
          children.add(TextSpan(text: v, style: ts));
        }
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
