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

```
core.dig          - Extract from the input value (object or array) using a path.
core.chain        - Applies a chain of lenses to an input value
core.mapping      - Converts the input value via a key:value mapping
core.literal      - Returns a constant value takens as lens definition

str.strip         - Remove leading and trailing spaces of an input string
str.split         - Splits the input string as an array
str.downcase      - Converts the input string to lowercase
str.upcase        - Converts the input string to uppercase

skip.null         - Aborts the current lens transformation if nil

object.extend     - Adds key/value(s) to the input object
object.rename     - Rename some keys of the input object
object.transform  - Applies specific lenses to specific values of the input object
object.keys       - Applies a lens to all keys of the input object
object.values     - Applies a lens to all values of the input object
object.select     - Builds an object by selecting key/values from the input object

coerce.date       - Coerces the input value to a date
coerce.datetime   - Coerces the input value to a datetime
coerce.string     - Coerces the input value to a string (aka to_s)
coerce.integer    - Coerces the input value to an integer

array.compact     - Removes null from the input array
array.join        - Joins values of the input array as a string
array.map         - Apply a lens to each member of an Array

check.notEmpty    - Throws an error if the input is null or empty
```

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
