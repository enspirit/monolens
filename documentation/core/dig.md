# core.dig

Extracts from the input value (object or array) using a path.

```
core.dig: Object -> Any
  on_missing: null|fail = fail
  defn: [String] = []
```

This lens can be used to extract a value along a `defn`
path in the input object.

## Example

Applying the following lens:

```yaml
---
core.dig:
  defn: ['hobbies', 1, 'name']
```

to the following input:

```yaml
---
hobbies:
- { name: 'Programming' }
- { name: 'Databases' }
```

will return:

```yaml
---
'Databases'
```

## See also

Hash#dig and Array#dig in Ruby.
