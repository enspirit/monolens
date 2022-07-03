# core.mapping

Converts the input value via a key:value mapping.

```
core.mapping: String -> Any
  on_missing: default|fallback|fail|keep|null = fail
  defn: Object = {}
```

This lens takes a String as input and looks for the
value mapped to it in the `defn`.

## Example

Applying the following lens:

```yaml
---
core.mapping:
  defn: { todo: 'open', done: 'closed' }
```

to the following input:

```yaml
---
'todo'
```

will return:

```yaml
---
'open'
```
