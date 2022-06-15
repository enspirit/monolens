# object.values

Applies a lens to all values of the input object.

```
object.values: Object -> Object
  on_error: fail|handler|keep|null|skip|[...] = fail
  lenses: Lens
```

This lens transforms all values of its input object by
using the lenses provided.

## Example

Applying the following lens:

```yaml
---
object.values:
  lenses:
  - str.upcase

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
firstname: 'BERNARD'
company: 'ENSPIRIT'
```
