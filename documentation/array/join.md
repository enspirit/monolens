# array.join

Joins values of the input array as a string.

```
array.join: Array -> String
  separator: String = ' '
```

This lens builds the output string by concatenating the
values of the input array with a separator.

## Example

Applying the following lens:

```yaml
---
array.join:
  separator: ', '
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
'programming, databases'
```
