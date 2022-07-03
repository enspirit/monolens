# object.keys

Applies a lens to all keys of the input object.

```
object.keys: Object -> Object
  lenses: Lens
```

This lens transforms all keys of its input object by
using the lenses provided.

## Example

Applying the following lens:

```yaml
---
object.keys:
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
FIRSTNAME: 'Bernard'
COMPANY: 'Enspirit'
```
