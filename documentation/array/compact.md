# array.compact

Removes null from the input array.

```
array.compact: Array -> Array
```

This lens builds the output by copying the members of the
input array to a new array, except those that are null.

## Example

Applying the following lens:

```yaml
---
array.compact
```

to the following input:

```yaml
---
- programming
- ~
- databases
```

will return:

```yaml
---
- programming
- databases
```
