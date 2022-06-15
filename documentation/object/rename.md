# object.rename

Renames some keys of the input object.

```
object.rename: Object -> Object
  defn: Object<String -> String> = {}
```

This lens copies its input object but renames some keys
as specified by `defn`.

## Example

Applying the following lens:

```yaml
---
object.rename:
  defn: { firstname: name }
```

to the following input:

```yaml
---
firstname: 'Bernard'
company: 'Enspirit'
```

will return:

```yaml
---
name: 'Bernard'
company: 'Enspirit'
```
