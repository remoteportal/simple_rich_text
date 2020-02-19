library simple_rich_text;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

const Map<String, int> colorMap = {
  'aqua': 0x00FFFF,
  'black': 0x000000,
  'blue': 0x0000FF,
  'brown': 0x9A6324,
  'cream': 0xFFFDD0,
  'cyan': 0x46f0f0,
  'green': 0x00FF00,
  'gray': 0x808080,
  'grey': 0x808080,
  'mint': 0xAAFFC3,
  'lavender': 0xE6BEFF,
  'new': 0xFFFF00,
  'olive': 0x808000,
  'orange': 0xFFA500,
  'pink': 0xFFE1E6,
  'purple': 0x800080,
  'red': 0xFF0000,
  'silver': 0xC0C0C0,
  'white': 0xFFFFFF,
  'yellow': 0xFFFF00
};

Color parseColor(String color) {
//  print("parseColor: $color");
  var v = colorMap[color];
  if (v == null) {
    return Colors.red;
  } else {
//    return Color(v);
//    return Colors.green;
//    int n = Color(v);
    Color out = Color((0xff << 24) | v);
//    print("parseColor: $color => $out");
    return out;
  }
}

/// Widget that renders a string with sub-string highlighting.
class SimpleRichText extends StatelessWidget {
  SimpleRichText(
      {@required this.text,
      this.chars,
      this.context,
      this.fussy,
      this.log,
      this.style});

  final String chars;

  /// For navigation
  final BuildContext context;

  /// Throw exception if tags not closed (e.g., "this is *bold" because no closing * character)
  final bool fussy;

  /// Pass in true for debugging/logging/trace
  final bool log;

  /// The {TextStyle} of the {SimpleRichText.text} that isn't highlighted.
  final TextStyle style;

  /// The String to be displayed using rich text.
  final String text;

  /// The {TextStyle} of the {SimpleRichText.term}s found.
//  final TextStyle textStyleHighlight;

  @override
  Widget build(BuildContext context) {
    if (text == null || text.isEmpty) {
      return Text('');
    } else {
      //print('text: $text');
      List<InlineSpan> children = [];

      Set set = Set();

      // split into array
      List<String> spanList = text.split(RegExp(chars ?? r"[*~/_\\]"));
      //print("len=${spanList.length}: $spanList");

      if (spanList.length == 1) {
        print("trivial");
        if (style == null) {
          return Text('');
        } else {
          return Text(text, style: style);
        }
      } else {
        int i = 0;
        bool acceptNext = true;
        String cmd;

        void wrap(String v) {
          //print("wrap: $v set=$set");

          Map<String, String> map = {};

          if (cmd != null) {
            var pairs = cmd.split(';');
            for (var pair in pairs) {
              var a = pair.split(':');
              if (a.length == 2) {
                map[a[0].trim()] = a[1].trim();
              } else {
                throw "attribute value is missing a value (e.g., you passed {key} but not {key:value}";
              }
            }
            if (log ?? false) print("attributes: $map");
          }

          TextStyle ts;
          if (style == null) {
            //TODO//H//TRAVESTY: needless duplicated code
            ts = TextStyle(
                color: map.containsKey('color')
                    ? parseColor(map['color'])
                    : DefaultTextStyle.of(context)
                        .style
                        .color, //WARNING: not sure if this is correct?
                decoration: set.contains('_')
                    ? TextDecoration.underline
                    : TextDecoration.none,
                fontStyle:
                    set.contains('/') ? FontStyle.italic : FontStyle.normal,
                fontWeight:
                    set.contains('*') ? FontWeight.bold : FontWeight.normal);
          } else {
            ts = style.copyWith(
                color: map.containsKey('color')
                    ? parseColor(map['color'])
                    : style.color,
                decoration: set.contains('_')
                    ? TextDecoration.underline
                    : TextDecoration.none,
                fontStyle:
                    set.contains('/') ? FontStyle.italic : FontStyle.normal,
                fontWeight:
                    set.contains('*') ? FontWeight.bold : FontWeight.normal);
          }

          if (map.containsKey('pop') ||
              map.containsKey('push') ||
              map.containsKey('repl')) {
//            print("BBB cmd=$cmd");
//          GestureDetector
//        children.add(WidgetSpan(child: Text('****')));
//          children.add(WidgetSpan(
//              child: GestureDetector(
//            child: Text('CLICK'),
//            onTap: () async {
//              //print("TAPPED");
//            },
//          )));

            assert(context != null, 'must pass context if using route links');

            onTapNew(String caption, Map m) {
              assert(m != null);
              if (map.containsKey('push')) {
                String v = map['push'];
                return () {
                  if (log ?? false) print("TAP: PUSH: $caption => /$v");
                  assert(v != null);
                  Navigator.pushNamed(context, '/$v');
                };
              } else if (map.containsKey('repl')) {
                String v = map['repl'];
                return () {
                  if (log ?? false) print("TAP: POP&PUSH: $caption => /$v");
                  assert(v != null);
                  Navigator.popAndPushNamed(context, '/$v');
                };
              } else {
                return () {
                  if (log ?? false) print("TAP: $caption => pop");
                  Navigator.pop(context);
                };
              }
            }

            children.add(TextSpan(
                text: v,
                // Beware!  This class is only safe because the TapGestureRecognizer is not given a deadline and therefore never allocates any resources.
                // In any other situation -- setting a deadline, using any of the less trivial recognizers, etc -- you would have to manage the gesture recognizer's lifetime
                // and call dispose() when the TextSpan was no longer being rendered.
                // Since TextSpan itself is @immutable, this means that you would have to manage the recognizer from outside
                // the TextSpan, e.g. in the State of a stateful widget that then hands the recognizer to the TextSpan.
                recognizer: TapGestureRecognizer()..onTap = onTapNew(v, map),
                style: ts));
          } else {
            children.add(TextSpan(text: v, style: ts));
          }
        }

        void toggle(String m) {
          if (m == r'\') {
            String c = text.substring(i + 1, i + 2);
            //print("quote: i=$i: $c");
            wrap(c);
            acceptNext = false;
          } else {
            if (acceptNext) {
              if (set.contains(m)) {
                //print("REM: $m");
                set.remove(m);
              } else {
                //print("ADD: $m");
                set.add(m);
              }
            }

            acceptNext = true;
          }
        }

        for (var v in spanList) {
//          print("========== $v ==========");
          cmd = null; //TRY
          if (v.isEmpty) {
            if (i < text.length) {
              String m = text.substring(i, i + 1);
//          //print("e: $m");
              toggle(m);
              i++;
            }
          } else {
            int adv = v.length;
            if (v[0] == '{') {
              if (log ?? false) print("link: $v");
              int close = v.indexOf('}');
              if (close > 0) {
                cmd = v.substring(1, close);
                if (log ?? false) print("AAA cmd=$cmd");
                v = v.substring(close + 1);
//                print("remaining: $v");
              }
            }
            wrap(v);
            i += adv;
            if (i < text.length) {
              String m = text.substring(i, i + 1);
              //print("*** format: $m");
              toggle(m);
              i++;
            }
          }
        }

        if ((fussy ?? false) && set.isNotEmpty) {
          throw 'simple_rich_text: not closed: $set'; //TODO: throw real error?
        }

        return RichText(text: TextSpan(children: children));
      }
    }
  }
}
