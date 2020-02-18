# easy_rich_text

# examples
```
this is /italic/
this is *bold*
this is not \*bold\*
this is _underline_
go to _home_{/home} page
go to _home{/route}_ page
go to _{/route}home_ page
this is ~important~(red).
this is _*bold and underlined*_.
```


# Requirements
Ancestor MUST have textDirection set (required by internal RichText widget), either through MaterialApp widget or explicitly wrapped by a Directionality widget:
```
Directionality(
    child: EasyRichText(text: 'Peter', term: 't'),
    textDirection: TextDirection.ltr)
```


# Pull Requests
Pull requests are welcome!


# Usage
Add a new dependency line to your project/pubspec.yaml file:

```yaml
dependencies:
  ...
  substring_highlight: ^0.1.3      # use latest version
```

Don't forget to *flutter pub get*.


# Examples
## Default Styling Example
### Code:
As an example, the following code snippet uses this package to highlight matching characters in each search result:  
```
import 'package:substring_highlight/substring_highlight.dart';

...

  @override
  Widget build(BuildContext context) (
    return Container(
      padding: const EdgeInsets.all(12),
      child: EasyRichText(
        text: dropDownItem,     // search result string from database or something
        term: searchTerm,       // user typed "et"
      ),
    );
  )
```
### Output:
![Screenshot](example.png)



## Customized Styling Example
### Code:
This example adds 'textStyle' and 'textStyleHighlight' to change the colors of the text:  
```
import 'package:substring_highlight/substring_highlight.dart';

...

  @override
  Widget build(BuildContext context) (
    return Container(
      padding: const EdgeInsets.all(12),
      child: EasyRichText(
        text: dropDownItem,                         // each string needing highlighting
        term: searchTerm,                           // user typed "m4a"        
        textStyle: TextStyle(                       // non-highlight style                       
          color: Colors.grey,
        ),
        textStyleHighlight: TextStyle(              // highlight style
          color: Colors.black,
          decoration: TextDecoration.underline,
        ),        
      ),
    );
  )
```
### Output:
![Screenshot](example2.png)