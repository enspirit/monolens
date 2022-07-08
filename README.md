# Monolens - Declarative data transformations

Declarative data transformations expressed as simple .yaml or
.json files. They are great to

- clean an Excel file
- transform a .json file
- transform data from a .csv file
- upgrade a .yaml configuration
- etc.

Monolens let's you tackle those tasks with small programs that are
simple, declarative, robust, secure, reusable and sharable.

## Features / Limitations

* Declarative & language agnostic
* Allows transforming scalars (e.g. string, dates), objects and arrays.
* Support for (simplified) jsonpath interpolation when defining objects
* Support for macros (monolens is an homoiconic language)
* Secure: not Turing Complete, no code injection, no RegExp DDoS

* Requires ruby >= 2.6
* Not reached 1.0 yet, still experimental

## Documentation & Examples

Please refer to the `documentation/` folder for a longer introduction,
documentation of the stdlib, and documented use-cases:

- [Introduction](./documentation/1-introduction.md)
- [Standard library](./documentation/stdlib)
- [Use cases](./documentation/use-cases)
  - [Kubernetes data templates](./documentation/use-cases/data-templates/)
  - [Migrating database seeds](./documentation/use-cases/data-transformation/)

## Getting started

### In shell

```
gem install monolens
```

Then:

```shell
monolens --help
monolens lens.yaml input.json
```

### In ruby

```ruby
# Gemfile
gem 'monolens', '< 1.0'
```

```ruby
require 'monolens'
require 'json'

lens   = Monolens.load_file('lens.yml')
input  = JSON.parse(File.read('input.json'))
result = lens.call(input)
```

## Credits

* Monolens is inspired by [Project Cambria](https://www.inkandswitch.com/cambria/)
but is not as ambitious, and is not currently compatible with it.

* The name of some lenses mimic Tutorial D / relational algebra (Date & Darwen).
  See also [Bmg](https://github.com/enspirit/bmg)

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
