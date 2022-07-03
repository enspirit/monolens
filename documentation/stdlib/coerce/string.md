# coerce.string

Coerces the input value to a string (aka to_s)

```
coerce.string: Any -> String
```

This lens convert its input to a String.

Note that this lens always succeeds, as it simply calls
Ruby's `#to_s` on the input.

## Example

Applying the following lens:

```yaml
---
array.map:
  on_error: 'null'
  lenses:
  - coerce.string
```

to the following input:

```yaml
---
- '12'
- 12
- ~
- 2022-10-01
```

will return:

```yaml
---
- '12'
- '12'
- ''
- '2022-10-01'
```
