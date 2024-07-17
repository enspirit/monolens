# str.nullIfEmpty

If the input string is empty, returns null

```
str.nullIfEmpty: String -> String|Null
```

## Example

Applying the following lens:

```yaml
---
array.map:
- str.nullIfEmpty
```

to the following input:

```yaml
---
- "foo"
- ""
```

will return:

```yaml
---
- foo
- ~
```
