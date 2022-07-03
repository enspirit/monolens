# str.split

Splits the input string as an array.

```
str.split: String -> Array<String>
  separator: String = ' '
```

This lens splits its input string to an array of
strings using a separator.

## Example

Applying the following lens:

```yaml
---
str.split: { separator: ',' }
```

to the following input:

```yaml
---
'foo,bar'
```

will return:

```yaml
---
- foo
- bar
```
