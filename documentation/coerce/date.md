# coerce.date

Coerces the input value to a datetime.

```
coerce.date: String|Date -> Date
  formats: [String|Null] = [null]
```

This lens takes a String as input and attempts to
parse it as a Date object.

Optional formats can be passed and will be tested
against the input string until one of them succeeds
(using Ruby's `Date#strptime`).

When the input is already a Date, the lens returns
it unchanged.
