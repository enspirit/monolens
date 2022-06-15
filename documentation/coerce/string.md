# coerce.string

Coerces the input value to a string (aka to_s)

```
coerce.string: Any -> String
```

This lens convert its input to a String.

Note that this lens always succeeds, as it simply calls
Ruby's `#to_s` on the input.
