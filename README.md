# simple_rich_text

Easily format Flutter text with simple format characters.

Motivation: lowest-possible development friction to add color, formatting, and named-route navigation to Flutter text.

In comparision, [easy_rich_text](https://pub.dev/packages/easy_rich_text) requires lots of code (i.e, patternList of EasyRichTextPattern objects). 


## Input
```
SimpleRichText(
    text: r'*_/this is all three*_/ (*{color:red}bold*, _{color:green}underlined_, and /{color:brown}italicized/). _{push:home;color:blue}clickable hyperlink to home screen_',
    style: TextStyle(color: Colors.yellow))
```

## Output
![Screenshot](example.png)

 

# Improvements, Bugs, and Deficiencies

- [ ] user-definable format characters
- [ ] user-definable callback functions for custom formatting
- [ ] support non-named navigation (only pushNamed, etc., supported at present)  



# Format Characters

These are non-standard (not markdown compatible) but are more intuitive in my opinion.

You can use multiple characters at the same time:
```
"this is _/underlined and italicized/_.
```

If using multiple characters the open and closed sequences don't need to be in palindrome order:

```
"these are */equivalent/*."
"these are */equivalent*/."
```

| character      | format effect                | example |
|-----------|----------------------|----------------------|
| asterisk (*)       | bold            | this is *bold* |
| slash (/)       | italics            | this is /italicized/ |
| underscore (_)       | underline            | this is _underlined_ |


# Attributes

Attribute pairs are placed in curly brackets immediately after first character marker.
Each pair is separated by a semicolon (;) and can be in any order.
Each pair has syntax name:value.



| key      | meaning                | underlying Dart code |
|-----------|----------------------|----------------------|
| color   | red, blue, etc           | textStyle.color: *color-value* |
| pop       | pop the navigation stack            |  Navigator.pop(context);  |
| push       | push the value onto the navigation stack            | Navigator.pushNamed(context, '/$route');  |
| repl       | replace the top route on the navigation stack            | Navigator.popAndPushNamed(context, '/$route');  |


# Colors Supported

Change text color by passing color as attribute:

## Example
```
"this is blue hyperlink to the _{color:blue,push:calendar}calendar_ screen"
```

| color:color_value      | hex value |
|-----------|-----------|
| aqua | 0x00FFFF |
| black | 0x000000 |
| blue | 0x0000FF |
| brown | 0x9A6324 |
| cream | 0xFFFDD0 |
| cyan | 0x46f0f0 |
| green | 0x00FF00 |
| gray | 0x808080 |
| grey | 0x808080 |
| mint | 0xAAFFC3 |
| lavender | 0xE6BEFF |
| new | 0xFFFF00 |
| olive | 0x808000 |
| orange | 0xFFA500 |
| pink | 0xFFE1E6 |
| purple | 0x800080 |
| red | 0xFF0000 |
| silver | 0xC0C0C0 |
| white | 0xFFFFFF |
| yellow |0xFFFF00 |



# Features

- support text hyperlinks to other screens by preceding formatted text with route inside curly brackets:  e.g., "... _{calendar}go to calendar screen_".




# Sample Inputs:
```
'this is /italic/'

'this is *bold*'

'*_/this is all three*_/ (*bold*, _underlined_, and /italicized/)'

'you can quote characters to NOT format a word \*bold\*'

'this is _underline_'

'go to _{/myroute}home_ page'

'this is ~important~(red).'

'this is _*bold and underlined*_.'
```


# Requirements
Ancestor MUST have textDirection set (required by internal RichText widget), either through MaterialApp widget or explicitly wrapped by a Directionality widget:
```
Directionality(
    child: SimpleRichText(text: 'Peter', term: 't'),
    textDirection: TextDirection.ltr)
```


# Pull Requests
Pull requests are welcome!


# Usage
Add a new dependency line to your project/pubspec.yaml file:

```yaml
dependencies:
  ...
  simple_rich_text: ^1.0.32      # use latest version
```

Don't forget to *flutter pub get*.


# Examples

See the example directory.