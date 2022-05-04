# Monolens - Declarative data transformation scripts

Monolens implements declarative data transformation
pipelines. It is inspired by [Project Cambria](https://www.inkandswitch.com/cambria/)
but is not as ambitious, and is not currently compatible with it.

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
- map:
  - object.transform
      status:
      - str.upcase
      body:
      - str.strip
  - object.rename
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
core.map          - Apply a lens to each member of an Array
core.chain        - Applies a chain of lenses to an input value

str.strip         - Remove leading and trailing spaces of an input string
str.downcase      - Converts the input string to lowercase
str.upcase        - Converts the input string to uppercase

skip.null         - Aborts the current lens transformation if nil

object.rename     - Rename some keys of the input object
object.transform  - Applies specific lenses to specific values of the input object
object.keys       - Applies a lens to all keys of the input object
object.values     - Applies a lens to all values of the input object

coerce.date       - Coerces the input value to a date
coerce.datetime   - Coerces the input value to a datetime

array.compact     - Removes null from the input array
```

## Public API

This library follows semantics versioning 2.0.

**It has NOT reached 1.0 and is currently unstable.**

Anyway, the public interface will cover at least the following:

* `Monolens.lens` factory method and its behavior

* The list of available lenses, their behavior and available options.

* Exception classes: `Monolens::Error`, `Monolens::LensError`

Everything else is condidered private and may change any time
(i.e. even on patch releases).

## Contributing

Please use github issues and pull requests, and favor the latter if possible.

## Licence

This software is distributed by Enspirit SRL under a MIT Licence. Please
contact Bernard Lambeau (blambeau@gmail.com) with any question.
