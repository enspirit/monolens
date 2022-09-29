# core.mapping

Converts the input value via a key:value mapping.

```
core.mapping: String -> Any
  on_missing: default|fallback|fail|keep|null = fail
  key_hash: Lens = null
  defn: Object = {}
```

This lens takes a String as input and looks for the
value mapped to it in the `defn`. If a `key_hash`
option is present, it's used as a lens to apply on
the keys before looking for a mapping.

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

### With a lens to hash the keys


Applying the following lens:

```yaml
---
core.mapping:
  defn: { todo: 'open', done: 'closed' }
  key_hash: 'str.downcase'
```

to the following input:

```yaml
---
'TODO'
```

will return:

```yaml
---
'open'
```
