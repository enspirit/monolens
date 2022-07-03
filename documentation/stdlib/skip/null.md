# skip.null

Skips the current processing and returns nil as output.

```
skip.null: Any -> Null
```

This lens can be used to send a `skip` message to higher
stages when the input is null. This can be useful to stop
a lens that would otherwise result in an error.

## Example

Applying the following lens:

```yaml
---
array.map:
  lenses:
  - skip.null
  - str.upcase
```

to the following input:

```yaml
---
- programming
- ~
- databases
```

will return:

```yaml
---
- PROGRAMMING
- ~
- DATABASES
```

Not using `skip.null` in such an example would result in an
error being raised by `str.upcase` (that could be catched
with an `on_error` on the `array.map`). An alternative is:

```yaml
---
array.map:
  on_error: skip
  lenses:
  - str.upcase
```
