# str.strip

Removes leading and trailing spaces of the input string.

```
str.strip: String -> String
```

This lens removes leading and trailing spaces from its
input.

## Example

Applying the following lens:

```yaml
---
array.map:
  lenses:
  - str.strip
```

to the following input:

```yaml
---
- foo
-   bar
- 'foo bar   '
```

will return:

```yaml
---
- foo
- bar
- foo bar
```
