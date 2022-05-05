## 0.3.0

* BREAKING: object.select, object.rename and object.transform
  now expect their selection/renaming/transformation to be
  provided under a `defn` key. This allows for adding options
  later.

  Before:

  ```yaml
  - object.select:
      firstname: name
  ```

  After

  ```yaml
  - object.select
      defn:
        firstname: name
  ```

* array.map now supports an `on_error` option with possible
  values `null`, `skip`, `raise` or `handler`. The latter works
  with an `:error_handler` world entry provided at call time.

  By default, using the handler will skip the current production.
  A combination can be specified, such as `['handler', 'null']`.

* object.transform now supports an `on_missing` option with
  possible values `null`, `skip` or `raise`. Default behavior is
  to raise an error if the input object lacks a key.

## 0.2.0 - 2022-05-05

* BREAKING: (core.)map moved as array.map, where it belongs

* Add object.select lens.
* Add array.join lens.
* Add str.split lens.
* Add core.mapping lens.

## 0.1.0 - 2022-05-04

Birthday.
