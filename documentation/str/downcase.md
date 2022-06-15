# str.downcase

Converts the input string to lowercase.

```
str.downcase: String -> String
```

This lens converts its input to the same string but
in lower case.

## Example

Applying the following lens:

```yaml
---
array.map:
  lenses:
  - str.downcase
```

to the following input:

```yaml
---
- FOO
```

will return:

```yaml
---
- foo
```
