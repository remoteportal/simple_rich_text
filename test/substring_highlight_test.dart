import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

// https://flutter.dev/docs/cookbook/testing/widget/introduction#3-create-a-testwidgets-test

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('test the thing!', (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        child: EasyRichText(text: 'Peter', term: 't'),
        textDirection: TextDirection.ltr));
  });
}
