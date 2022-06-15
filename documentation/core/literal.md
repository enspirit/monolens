# core.literal

Returns a constant value takens as lens definition.

```
core.literal: Any -> Any
  defn: Any = null
```

This lens returns the value taken as `defn`.

## Example

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
