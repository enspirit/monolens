## 0.6.4 - 2024-07-17

* Add `str.nullIfEmpty` that converts empty string by a null
* Add `core.digs`
* Add a :concat strategy to `object.select`

## 0.6.3 - 2024-07-09

* Add `coerce.array`

## 0.6.2 - 2022-09-29

* Add `key_hash` option to `core.mapping`.

## 0.6.1 - 2022-07-15

* Add the possibility to add examples to lens files, with typical
  input and output data.

* `--test` option to the commandline, that checks that the embedded
  examples are indeed correct.

* `--[no]-paint` options to the commandline, to enable or disable
  colors of error messages.

* The commandline now correctly exits with a status code of 1 when an
  error occurs.

## 0.6.0 - 2022-07-08

* Add support for `macros` in a lens file.

### Lenses

* (BREAKING): `core.mapping` now takes a `defn` instead of `values`.
  Backward compatibility is provided but will be removed in 1.0.

* Add `object.allbut` lens, that allows removing specific object
  keys.

* Add `object.merge` lens, that supports normal and deep merge, as
  well as controlling priority on shared keys.

* `core.literal` now supports (simplified) jsonpath interpolation
  in strings and complex objects.

* `core.mapping` now supports a `keep` strategy for `:on_error`,
  that simply returns the input key.

* `array.map` now supports a `keep` strategy for `:on_error`,
  that simply keeps input members on which the sub lens fails.

### Commandline

* (BREAKING): removed the `--no-map` option that makes little sense.

* Add `-I` and `-r` options to commandline. They mimic ruby's.

* Add `--map` and `--on-error` options to commandline. They can be
  used to write singular object lenses and easily test them against
  .csv and .xlsx files.

* Add `--literal` option to the commandline. Handy to "execute" a
  pure object definition (with jsonpath expressions) against a json
  file.

* Add `--yaml` (resp. `--json`) options to the commandline, to dump the
  result in yaml (resp. json). The default stays json.

* Add `--stream` option to the commandline, to output each item of the
  result separately.

* Add `--override` option to the commandline, to override the input data
  file with the result of the transformation.

* Add `--stdin` option to the commandline, that takes the input data as .json
  from stdin instead of the file passed as second argument.

* Add missing binary in the ruby gem.

## 0.5.3 - 2022-06-09

* Add core.literal lens.

## 0.5.2 - 2022-05-20

* Add check.notEmpty lens that throw an error if the input is
  null or empty

## 0.5.1 - 2022-05-13

* Enhance ErrorHandler (Enumerable).

## 0.5.0 - 2022-05-13

* BREAKING: core.mapping fails by default when no corresponding
  output is found for an input.

  `:fail_if_missing` option is no longer supported, and replaced
  by `:on_missing` that supports `fail`, `null`, `default`
  and `fallback` strategies.

* object.select now select a `:strategy` option that affects the
  behavior when defn values are array.

  When set to 'all' (default), the selection will build an array
  as output (as before). When set to 'first', the output is the
  first value for which the key has been found on input.

## 0.4.0 - 2022-05-12

* Add a monolens commandline tool.

* Add core.dig that extracts a value using a path. Supports
  the :null and :fail on_missing strategies.

* Add object.extend that adds new key/values on the input
  object. Supports the :null, :skip, :handler, and :fail
  on_error strategies.

* Add coerce.integer

* object.select now supports an array of keys as defn and
  keeps those keys only.

* coerce.date (resp. coerce.datetime) are idempotent: they
  return their input if it's already a Date (resp. DateTime)

* BREAKING (?): coerce.datetime now uses DateTime.parse
  instead of `strptime` when there are no formats proposed.

* coerce.datetime now recognizes a `:parser` option that is
  used for actual parsing (through `parse` or `strptime`).

  This allows using ActiveRecord's Timezone instances as
  actual parsers. Note that the result is still a DateTime,
  as `to_datetime` is called on the result.

## 0.3.0 - 2022-05-06

* BREAKING: str.strip fails if input is not a string.

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

* Add coerce.string, aka toString or to_s

* When an error occurs, the LensError class supports a `location`
  field that tracks the path within the input as an array of
  parts, e.g. `[0, :firstname]` for an error occuring on the
  `:firstname` field of the object at position 3 in an array
  (so 4th object, as positions start at 0 as usual).

* array.map and object.values now supports an `on_error` option
  with possible values `null`, `skip`, `fail` or `handler`. The
  latter works with an `:error_handler` world entry provided at
  call time.

  object.values also support a `keep` option that preserves the
  original value.

  By default, using the handler will skip the current production.
  A combination can be specified, such as `['handler', 'null']`.

* object.transform and object.select now support an `on_missing`
  option with possible values `null`, `skip` or `fail`. Default
  behavior is to fail if the input object lacks a key.

## 0.2.0 - 2022-05-05

* BREAKING: (core.)map moved as array.map, where it belongs

* Add object.select lens.
* Add array.join lens.
* Add str.split lens.
* Add core.mapping lens.

## 0.1.0 - 2022-05-04

Birthday.
