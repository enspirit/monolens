# object.merge

(Deep) merges the input object with `defn`.

```
object.merge: Object -> Object
  deep: Boolean = true
  priority: String = 'defn'
  defn: Object = {}
```

This lens merges two objects: the input and defn and returns the result.

When `deep` is set to true, the merge applies recursively on sub objects
with the same key.

When a conflict arises (same key, different values) the value from the
`defn` is taken by default. You can set `priority` to 'input' to reverse
this behavior.

## Example

Applying the following lens:

```yaml
---
object.merge:
  priority: input
  deep: true
  defn:
    name: Monolens
    version: "1.0"
    links:
      github: "https://github.com/enspirit/monolens"
```

to the following input:

```yaml
---
version: "1.2"
links:
  owner: "https://enspirit.be/"
  github: "https://github.com/enspirit/monolens/"  # note the trailing slash
```

will return:

```yaml
---
name: Monolens
version: "1.2"
links:
  owner: "https://enspirit.be/"
  github: "https://github.com/enspirit/monolens/"
```
