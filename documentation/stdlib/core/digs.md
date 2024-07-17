# core.digs

Plural form of core.dig, returns an array with multiple
digs at once

```
core.digs: Object -> [Any]
  on_missing: null|fail = fail
  defn: [[String|Integer]] = []
```

This lens can be used to extract multiple values along some `defn`
paths in the input object.

## Example

Applying the following lens:

```yaml
---
core.digs:
  defn:
  - ['foo']
  - ['hobbies', 1, 'name']
```

to the following input:

```yaml
---
foo: Hello
hobbies:
- { name: 'Programming' }
- { name: 'Databases' }
```

will return:

```yaml
---
- Hello
- Databases
```
