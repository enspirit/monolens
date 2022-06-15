# coerce.integer

Coerces the input value to an integer.

```
coerce.integer: String|Integer -> Integer
```

This lens attempts to convert its input to an Integer, or
raises an error.

When the input is already an Integer, the lens returns
it unchanged.

## Example

Applying the following lens:

```yaml
---
array.map:
  on_error: 'null'
  lenses:
  - coerce.integer
```

to the following input:

```yaml
---
- '12'
- 12
- 12.5
- not a number
- mix 12
- '12.5'
```

will return:

```yaml
---
- 12
- 12
- 12
- ~
- ~
- ~
```
