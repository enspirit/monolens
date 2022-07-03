# core.literal

Returns a value expressed as a literal, with support for jsonpath
interpolation on input.

```
core.literal: Any -> Any
  defn: Any = null
```

This lens returns the value taken by instantiating `defn`, that is
replacing all (simplified) jsonpath expressions by the corresponding
values found on the input object.

See also: simplified jsonpath expressions.

## Examples

### Pure literals

Applying the following lens:

```yaml
---
core.literal:
  defn: foo
```

to the following input:

```yaml
---
```

will return:

```yaml
---
foo
```

### JSONPath interpolations


Applying the following lens:

```yaml
---
core.literal:
  defn:
    name: Monolens
    version: $.libs[0].version
    interpolated: Monolens v$(.libs[0].version)
```

to the following input:

```yaml
---
libs:
- name: Monolens
  version: 0.7
- name: Bmg
  version: 0.20
- name: Finitio
  version: 0.14
```

will return:

```yaml
---
name: Monolens
version: 0.7
interpolated: Monolens v0.7
```
