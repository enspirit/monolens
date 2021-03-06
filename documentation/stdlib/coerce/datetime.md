# coerce.datetime

Coerces the input value to a datetime.

```
coerce.datetime: String|DateTime -> DateTime
  formats: [String|Null] = [null]
  parser: Any(#parse && #strptime) = DateTime
```

This lens takes a String as input and attempts to
parse it as a DateTime object.

Optional formats can be passed and will be tested
against the input string until one of them succeeds
(using Ruby's `DateTime#strptime`). A null format
indicates the lens to use `DateTime#parse` instead.

A specific parser can be passed as option. It must
respond to `strptime` and `parse`.

When the input is already a DateTime, the lens returns
it unchanged.

## Example

Applying the following lens:

```yaml
---
array.map:
  on_error: 'null'
  lenses:
  - coerce.datetime
```

to the following input:

```yaml
---
- '2022-12-10T18:00:00+01:00'
```

will return (as a DateTime class):

```yaml
---
- 2022-12-10T18:00:00+01:00
```
