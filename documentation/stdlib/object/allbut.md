# object.allbut

Removes some keys from the input object.

```
object.allbut: Object -> Object
  defn: Array<String> = []
```

This lens copies its input object but the keys
specified as `defn`.

## Example

Applying the following lens:

```yaml
---
object.allbut:
  defn: [ 'age', 'hobbies' ]
```

to the following input:

```yaml
---
firstname: 'Bernard'
company: 'Enspirit'
age: 42
hobbies: [ 'programming', 'databases' ]
```

will return:

```yaml
---
firstname: 'Bernard'
company: 'Enspirit'
```
