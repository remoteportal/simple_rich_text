library simple_rich_text;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

Color? parseColor(String? color) {
  if (color == null || color.isEmpty) {
    return null;
  }
  if (colorMap.containsKey(color)) {
    return Color((0xff << 24) | colorMap[color]!);
  }
  // custom color !
  String hexColor = color.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  try {
    return Color(int.parse("0x$hexColor"));
  } catch (e) {
    return null;
  }
}

/// Widget that renders a string with sub-string highlighting.
class SimpleRichText extends StatelessWidget {
  SimpleRichText(this.text,
      {this.chars,
      this.context,
      this.fussy,
      this.logIt = false,
      this.maxLines,
      this.pre,
      this.post,
      this.style = const TextStyle(),
      this.textAlign,
      this.textOverflow,
      this.textScaleFactor});

  final String? chars;

  /// For navigation
  final BuildContext? context;

  /// Throw exception if tags not closed (e.g., "this is *bold" because no closing * character)
  final bool? fussy;

  /// Pass in true for debugging/logging/trace
  final bool logIt;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int? maxLines;

  /// optional leading TextSpan
  final TextSpan? pre;

  /// optional trailing TextSpan
  final TextSpan? post;

  /// The {TextStyle} of the {SimpleRichText.text} that isn't highlighted.
  final TextStyle? style;

  /// The String to be displayed using rich text.
  final String text;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// How visual overflow should be handled.
  final TextOverflow? textOverflow;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  final double? textScaleFactor;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return Text('');
    } else {
      //print('text: $text');
      List<InlineSpan> children = [];

      if (pre != null) {
        children.add(pre!);
      }

      Set set = Set();

      bool containsNewLine = text.contains(r'\n');
      log('Contains new line: $containsNewLine');
      List<String> linesList = [];
      if (containsNewLine) {
        linesList = text.split(r'\n');
        log("lines=${linesList.length}: $linesList");
      } else {
        linesList.add(text);
      }

      // Apply modifications into all lines
      for (int k = 0; k < linesList.length; k++) {
        log('Line ${k + 1}: ${linesList[k]}');
        // split into array
        List<String> spanList =
            linesList[k].split(RegExp(chars ?? r"(?=(?![^{]*}))[*~/_\\]"));
        log("len=${spanList.length}: $spanList");

        if (spanList.length == 1) {
          log("trivial");
          if (style == null) {
            children.add(TextSpan(text: ''));
            // If no last line:
            if (k < linesList.length - 1) children.add(TextSpan(text: '\n'));
          } else {
            children.add(TextSpan(text: linesList[k], style: style));
            // If no last line:
            if (k < linesList.length - 1) children.add(TextSpan(text: '\n'));
          }
        } else {
          int i = 0;
          bool acceptNext = true;
          String? cmd;

          void wrap(String v) {
            log("wrap: $v set=$set");

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
              log("attributes: $map");
            }

            // TextDecorationStyle "values" is ignored
            TextDecorationStyle? _textDecorationStyle;
            if (map.containsKey('decorationStyle')) {
              if (map['decorationStyle'] == 'dashed')
                _textDecorationStyle = TextDecorationStyle.dashed;
              if (map['decorationStyle'] == 'double')
                _textDecorationStyle = TextDecorationStyle.double;
              if (map['decorationStyle'] == 'dotted')
                _textDecorationStyle = TextDecorationStyle.dotted;
              if (map['decorationStyle'] == 'solid')
                _textDecorationStyle = TextDecorationStyle.solid;
              if (map['decorationStyle'] == 'wavy')
                _textDecorationStyle = TextDecorationStyle.wavy;
            }

            TextStyle ts;
            ts = style!.copyWith(
              color: parseColor(map['color']) ?? style!.color,
              decoration: set.contains('_')
                  ? TextDecoration.underline
                  : TextDecoration.none,
              fontStyle:
                  set.contains('/') ? FontStyle.italic : FontStyle.normal,
              fontWeight:
                  set.contains('*') ? FontWeight.bold : FontWeight.normal,
              fontSize: map.containsKey('fontSize')
                  ? double.parse(map['fontSize']!)
                  : style!.fontSize,
              fontFamily: map.containsKey('fontFamily')
                  ? '${map['fontFamily']}'
                  : style!.fontFamily,
              backgroundColor:
                  parseColor(map['backgroundColor']) ?? style!.backgroundColor,
              decorationColor:
                  parseColor(map['decorationColor']) ?? style!.decorationColor,
              decorationStyle: _textDecorationStyle ?? style!.decorationStyle,
              decorationThickness: map.containsKey('decorationThickness')
                  ? double.parse(map['decorationThickness']!)
                  : style!.decorationThickness,
              height: map.containsKey('height')
                  ? double.parse(map['height']!)
                  : style!.height,
              letterSpacing: map.containsKey('letterSpacing')
                  ? double.parse(map['letterSpacing']!)
                  : style!.letterSpacing,
              wordSpacing: map.containsKey('wordSpacing')
                  ? double.parse(map['wordSpacing']!)
                  : style!.wordSpacing,
            );

            if (map.containsKey('pop') ||
                map.containsKey('push') ||
                map.containsKey('repl') ||
                map.containsKey('http')) {
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

              // assert(context != null, 'must pass context if using route links');

              onTapNew(String caption, Map m) {
                if (map.containsKey('push')) {
                  String v = map['push']!;
                  return () {
                    log("TAP: PUSH: $caption => /$v");
                    // assert(v != null);
                    Navigator.pushNamed(context, '/$v');
                    // Nav.push('/$v');
                  };
                } else if (map.containsKey('repl')) {
                  String v = map['repl']!;
                  return () {
                    log("TAP: POP&PUSH: $caption => /$v");
                    // assert(v != null);
                    Navigator.popAndPushNamed(context, '/$v');
                    //  Nav.repl('/$v');
                  };
                } else if (map.containsKey('http')) {
                  String v = map['http']!;
                  return () async {
                    log("TAP: HTTP: $caption => /$v");
                    // assert(v != null);
                    try {
                      await launch('http://$v');
                    } catch (e) {
                      log('Could not launch http://$v: $e');
                      try {
                        await launch('https://$v');
                      } catch (e) {
                        log('Could not launch https://$v: $e');
                      }
                    }
                  }; // TODO add possibility of tel, mailto, sms, whats,...?
                } else {
                  return () {
                    log("TAP: $caption => pop");
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
              String c = linesList[k].substring(i + 1, i + 2);
              log("quote: i=$i: $c");
              wrap(c);
              acceptNext = false;
            } else {
              if (acceptNext) {
                if (set.contains(m)) {
                  log("REM: $m");
                  set.remove(m);
                } else {
                  log("ADD: $m");
                  set.add(m);
                }
              }

              acceptNext = true;
            }
          }

          for (var v in spanList) {
            log("========== $v ==========");
            cmd = null; //TRY
            if (v.isEmpty) {
              if (i < linesList[k].length) {
                String m = linesList[k].substring(i, i + 1);
                toggle(m);
                i++;
              }
            } else {
              int adv = v.length;
              if (v[0] == '{') {
                log("link: $v");
                int close = v.indexOf('}');
                if (close > 0) {
                  cmd = v.substring(1, close);
                  log("AAA cmd=$cmd");
                  v = v.substring(close + 1);
                  log("remaining: $v");
                }
              }
              wrap(v);
              i += adv;
              if (i < linesList[k].length) {
                String m = linesList[k].substring(i, i + 1);
                log("*** format: $m");
                toggle(m);
                i++;
              }
            }
          }

          if ((fussy ?? false) && set.isNotEmpty) {
            throw 'simple_rich_text: not closed: $set'; //TODO: throw real error?
          }

          // If no last line:
          if (k < linesList.length - 1) children.add(TextSpan(text: '\n'));
        }
      }

      if (post != null) {
        children.add(post!);
      }

      return RichText(
          maxLines: this.maxLines ?? null,
          overflow: this.textOverflow ?? TextOverflow.clip,
          text: TextSpan(children: children),
          textAlign: this.textAlign ?? TextAlign.start,
          textScaleFactor:
              this.textScaleFactor ?? MediaQuery.of(context).textScaleFactor);
    } // else
  } // build

  void log(String s) {
    if (logIt) print('---- $s');
  }
} // class
