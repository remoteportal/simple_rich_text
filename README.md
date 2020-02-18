# simple_rich_text

Easily format Flutter text with simple format characters:

r'*_/this is all three*_/ (*bold*, _underlined_, and /italicized/). _{home}Click to navigate to home screen_'

![Screenshot](example.png)

 


# Format Characters

| character      | format effect                |
|-----------|----------------------|
| asterisk (*)       | bold            |
| slash (/)       | italicize            |
| underscore (_)       | underline            |



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
  simple_rich_text: ^1.0.28      # use latest version
```

Don't forget to *flutter pub get*.


# Examples

See the example directory.