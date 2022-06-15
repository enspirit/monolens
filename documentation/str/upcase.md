# str.upcase

Converts the input string to uppercase.

```
str.upcase: String -> String
```

This lens converts its input to the same string but
in upper case.

## Example

Applying the following lens:

```yaml
---
array.map:
  lenses:
  - str.upcase
```

to the following input:

```yaml
---
- foo
```

will return:

```yaml
---
- FOO
```
