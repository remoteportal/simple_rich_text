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

  /// The String searched by {EasyRichText.term}.
  final String text;

  /// The sub-string that is highlighted inside {EasyRichText.text}.
  final BuildContext context;

  /// The {TextStyle} of the {EasyRichText.text} that isn't highlighted.
  final TextStyle textStyle;

  /// The {TextStyle} of the {EasyRichText.term}s found.
  final TextStyle textStyleHighlight;

  @override
  Widget build(BuildContext context) {
    return Text(text);
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
}
