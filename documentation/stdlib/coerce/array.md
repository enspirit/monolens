# coerce.array

Coerces the input value to an array

```
coerce.array: Any -> Array
```

This lens convert its input to an Array.

Mimicing ruby, null is coerced to an empty array.
An array is kept unchanged.
Any other value is converted to a singleton array.

## Example

Applying the following lens:

```yaml
---
array.map:
  on_error: 'null'
  lenses:
  - coerce.array
```

to the following input:

```yaml
---
- ~
- 'foo'
- ['foo', 'bar']
```

will return:

```yaml
---
- []
- ['foo']
- ['foo', 'bar']
```
