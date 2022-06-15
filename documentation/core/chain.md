# coerce.chain

Applies a chain of lenses to an input value.

```
coerce.chain: [Lens] -> Lens
```

This lens simply takes a list of sublenses and apply
them in order (functional composition). It is mostly implicit
when using .yaml files and is used for constructions like
this:

```
lenses:
- ...
- ...
```
