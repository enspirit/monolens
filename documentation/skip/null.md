# skip.null

Sends a skip message if the input is null.

```
skip.null: Any -> Any
```

This lens can be used to send a `skip` message to higher
stages when the input is null.

The message will be cached by `skip` handlers on `on_missing`
and `on_error` clauses.
