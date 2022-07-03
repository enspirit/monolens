# object.select

Builds an object by selecting key/values from the input
object.

```
object.select: Object -> Object
  on_missing: fail|null|skip|[...] = fail
  strategy: all|first = all
  defn: Object<String -> String|[String]> = {}
```

This lens creates an output object by selecting some
keys of its input object as specified by `defn`. Each
pair of the `defn` maps an output key `o` to either
a key `i` of the input object, or an array of such keys.

When a single key is mapped, `o` will be mapped to
`input[i]`. When multiple keys are mapped, the result
depends on the specified strategy:
- when 'all', `o` will be mapped to an array with all
  values fetched.
- when 'first', `o` will be mapped to the first non
  null value that is found for a given `i`.

## Example

Applying the following lens:

```yaml
---
object.select:
  defn:
    name: ['firstname', 'lastname']
    company: company

```

to the following input:

```yaml
---
firstname: 'Bernard'
lastname: 'Lambeau'
company: 'Enspirit SRL'
```

will return:

```yaml
---
name: ['Bernard', 'Lambeau']
company: 'Enspirit SRL'
```
