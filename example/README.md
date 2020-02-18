# Example

```
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
      home: Scaffold(
          backgroundColor: Colors.grey,
          body: Center(child: EasyRichText(text: r'*_/this is all three*_/ (*bold*, _underlined_, and /italicized/). _{home}Click to navigate to home screen_'))),
    );
  }
}

```

# Output:
![Screenshot](example.png)
