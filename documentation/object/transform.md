# object.transform

Applies specific lenses to specific values of the input
object.

```
object.transform: Object -> Object
  on_missing: fail|null|skip|[...] = fail
  defn: Object<String -> Lens> = {}
```

This lens transforms its input object as specified in
`defn`. Each pair of the `defn` maps a key to a lens
that will be applied to the corresponding value of the
input object.

## Example

Applying the following lens:

```yaml
---
object.transform:
  defn:
    firstname:
    - str.upcase
    company:
    - str.split: { separator: ' ' }

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
firstname: 'BERNARD'
lastname: 'Lambeau'
company: ['Enspirit', 'SRL']
```
