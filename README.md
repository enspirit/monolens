# Monolens - Declarative data transformation scripts

Monolens implements declarative data transformation
pipelines. It is inspired by [Project Cambria](https://www.inkandswitch.com/cambria/)
but is not as ambitious, and is not currently compatible with it.

## Features / Limitations

* Allows defining common data transformations on scalars
  (e.g. string, dates), objects and arrays.
* Declarative & language agnostic
* Safe (no path to code injection)

* Requires ruby >= 2.6
* There is no validation of lens files for now

## Example

Given the following input file, say `input.json`:

```json
[
  {
    "status": "open",
    "body": " Hello world"
  },
  {
    "status": "closed",
    "body": " Foo bar baz"
  }
]
```

The following monolens file, say `lens.yml`

```yaml
---
version: 1.0
lenses:
- array.map:
  - object.transform:
      status:
      - str.upcase
      body:
      - str.strip
  - object.rename:
      body: description
```

will generate the following result:

```json
[
  {
    "status": "OPEN",
    "description": "Hello world"
  },
  {
    "status": "CLOSED",
    "description": "Foo bar baz"
  }
]
```

In ruby:

```ruby
require 'monolens'
require 'json'

lens   = Monolens.load_file('lens.yml')
input  = JSON.parse(File.read('input.json'))
result = lens.call(input)
```

## Available lenses

* [array.compact](documentation/array/compact.md): Removes null from the input array
* [array.join](documentation/array/join.md): Joins values of the input array as a string
* [array.map](documentation/array/map.md): Applies a lens to each member of an array

* [check.notEmpty](documentation/check/notEmpty.md): Throws an error if the input is null or empty

* [coerce.date](documentation/coerce/date.md): Coerces the input value to a date
* [coerce.datetime](documentation/coerce/datetime.md): Coerces the input value to a datetime
* [coerce.integer](documentation/coerce/integer.md): Coerces the input value to an integer
* [coerce.string](documentation/coerce/string.md): Coerces the input value to a string (aka to_s)

* [core.chain](documentation/core/chain.md): Applies a chain of lenses to an input value
* [core.dig](documentation/core/dig.md): Extracts from the input value (object or array) using a path
* [core.literal](documentation/core/literal.md): Returns a constant value takens as lens definition
* [core.mapping](documentation/core/mapping.md): Converts the input value via a key:value mapping

* [object.allbut](documentation/object/allbut.md): Removes some keys from the input object
* [object.extend](documentation/object/extend.md): Adds key/value(s) to the input object
* [object.keys](documentation/object/keys.md): Applies a lens to all keys of the input object
* [object.rename](documentation/object/rename.md): Renames some keys of the input object
* [object.select](documentation/object/select.md): Builds an object by selecting key/values from the input object
* [object.transform](documentation/object/transform.md): Applies specific lenses to specific values of the input object
* [object.values](documentation/object/values.md): Applies a lens to all values of the input object

* [skip.null](documentation/skip/null.md): Sends a skip message if the input is null

* [str.downcase](documentation/str/downcase.md): Converts the input string to lowercase
* [str.split](documentation/str/split.md): Splits the input string as an array
* [str.strip](documentation/str/strip.md): Removes leading and trailing spaces of the input string
* [str.upcase](documentation/str/upcase.md): Converts the input string to uppercase

## Public API

This library follows semantics versioning 2.0.

**It has NOT reached 1.0 and is currently unstable.**

Anyway, the public interface will cover at least the following:

* `Monolens.lens` factory method and its behavior

* The list of available lenses, their behavior and available options.

* Exception classes: `Monolens::Error`, `Monolens::LensError`

* bin/monolens, its args, options and general behavior

Everything else is condidered private and may change any time
(i.e. even on patch releases).

## Contributing

Please use github issues and pull requests, and favor the latter if possible.

## Licence

This software is distributed by Enspirit SRL under a MIT Licence. Please
contact Bernard Lambeau (blambeau@gmail.com) with any question.
