# check.notEmpty

Throws an error if the input is null or empty.

```
check.notEmpty: Any -> Any
  message: String = 'Input may not be empty'
```

This lens takes an Array, Object or String as input and fails
when empty or null. Otherwise the input is simply returned.

This lens is usually used together with a on_error handler
in higher stages.

## Example

Applying the following lens:

```yaml
---
array.map:
  on_error: skip
  lenses:
  - check.notEmpty
```

to the following input:

```yaml
---
- programming
- ~
- databases
- ''
```

will return:

```yaml
---
- programming
- databases
```
