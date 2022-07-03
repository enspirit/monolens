# array.map

Applies a lens to each member of an array.

```
array.map: Array -> Array
  on_error: fail|handler|keep|null|skip|[...] = fail
  lenses: Lens
```

This lens applies a sublens to every member of the input
array and collects the result as a new output array.

## Example

Applying the following lens:

```yaml
---
array.map:
  lenses:
  - str.upcase
```

to the following input:

```yaml
---
- programming
- databases
```

will return:

```yaml
---
- PROGRAMMING
- DATABASES
```
