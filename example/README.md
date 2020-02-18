# Example

```
import 'package:flutter/material.dart';
import 'package:easy_rich_text/easy_rich_text.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return new MaterialApp(
     home: Scaffold(
         body: Center(
             child: SubstringHighlight(
                 text: 'search me for search terms', term: 'search'))),
   );
 }
}
```

# Output:
![Screenshot](example3.png)