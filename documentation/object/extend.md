# object.extend

Adds key/value(s) to the input object.

```
object.extend: Object -> Object
  on_error: fail|handler|null|skip|[...] = fail
  defn: Object<String -> Lens> = {}
```

This lens extends its input object with new key/value
pairs as specified by `defn`. Each pair of the `defn`
associates a new key to a lens that, when evaluated on
the input object, brings the corresponding output value.

## Example

Applying the following lens:

```yaml
---
object.extend:
  defn:
    upcased:
    - core.dig: { defn: [firstname] }
    - str.upcase

```

to the following input:

```yaml
---
firstname: 'Bernard'
```

will return:

```yaml
---
firstname: 'Bernard'
upcased: 'BERNARD'
```
