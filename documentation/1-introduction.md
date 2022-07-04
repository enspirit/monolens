# Monolens - Declarative data transformations

This introduction defines the basic concepts of Monolens and gives an outline
for further readings.

- [What is Monolens?](#what-is-monolens)
- [What is a Lens?](#what-is-a-lens)
- [How do we represent lenses & programs as data?](#how-do-we-represent-lenses--programs-as-data)
- [How do we build larger programs?](#how-do-we-build-larger-programs)
- [Lenses that take other lenses as option](#lenses-that-take-other-lenses-as-option)
- [Objects as input & output](#objects-as-input--output)
- [Going further](#going-further)

## What is Monolens?

Monolens is a library and commandline tool (written in Ruby) to run declarative
programs that transform data.

Monolens can be seen as a data transformation language. That language is
[homoiconic](https://en.wikipedia.org/wiki/Homoiconicity#:~:text=A%20language%20is%20homoiconic%20if,treats%20%22code%20as%20data%22.)
since its source code is expressed as data, typically in .yaml (or .json) files.

This property allows Monolens to expose macros that let you factorize and reuse
otherwise repetitive source code.

## What is a Lens?

A lens is a pure function that takes data as input, and returns data as output.

A very simple example is the [`str.upcase`](./stdlib/str/upcase.md) lens. It
takes a string as input (say `Monolens`) and returns another string as output
(`MONOLENS`).

Some lenses accept options. For instance, the [`array.join`](./stdlib/array/join.md)
lens converts an array (input) to a string (output) by concatenating its elements
using a separator (option).

## How do we represent lenses & programs as data?

Most of the time, we create programs as .yaml files. For instance, the following
program will simply upcase its input:

```yaml
---
str.upcase
```

while the following one will concatenate its input array as a string:

```yaml
---
array.join:
  separator: ','
```

The first example is syntactic sugar for the following program:

```yaml
---
str.upcase: {}
```

The general form of a lens is thus a key/value, that maps the lens name to some
options. In other words, the .json equivalent of the two programs above are:

```json
{"str.upcase": {}}
```

and

```json
{"array.join": {"separator": ","}}
```

## How do we build larger programs?

Lenses compose like lego bricks. The way to express composition is through
an array of lenses. For instance, the following example will concatenate the
elements of its input ; that outputs a string that will then be upcased.

```yaml
---
- array.join:
    separator: ','
- str.upcase
```

Applying that program to the following input:

```yaml
---
- Monolens
- Finitio
- Bmg
```

will output:

```yaml
---
MONOLENS, FINITIO, BMG
```

In Monolens, we sometimes say that one has built a chain:

```
input -> array.join -> str.upcase -> output
```

In fact, the program above is syntactic sugar for a (rather normal) lens called
[`core.chain`](./stdlib/core/chain.md) to which sub-lenses are passed as an
option called `lenses`:

```yaml
---
core.chain:
  lenses:
  - array.join:
      separator: ','
  - str.upcase
```

As a general rule, everytime a lens is expected you can use `core.chain` to
use a chain of lenses instead. And everywhere `core.chain` is used, you can
use a simple array of lenses as syntactic sugar.

## Lenses that take other lenses as option

`core.chain` is different from `str.upcase` and `array.join` because it takes
other lenses as option. This is better known as
[high-order programming](https://en.wikipedia.org/wiki/Higher-order_programming).

In fact, `core.chain` is far from being alone to do that. For instance, the
program above (that upcases array elements as a comma-seperated string) can
also be written like this:

```yaml
---
- array.map:
    lenses:
    - str.upcase
- array.join:
    separator: ','
```

In this example, [`array.map`](./stdlib/array/map.md) is first used to upcase
each string of the input, and the result (another array) is then joined to
obtain the output string. We see that `array.map` takes sub-lenses as option,
very much like `core.chain`.

And so do other useful lenses, such as `object.keys`, `object.values`, and
`object.transform`.

## Objects as input & output

It is very common to work with objects in addition to strings, numbers and
arrays (which are the basic types offered by data languages like json or yaml).

The [`object.` stdlib module](./stdlib/object) provides useful lenses to
manipulate objects, like:
- converting the [keys](./stdlib/object/keys.md) or [values](./stdlib/object/values.md),
- [adding](./stdlib/object/extend.md), [removing](./stdlib/object/allbut.md) or
  [renaming](./stdlib/object/rename.md) properties,
- etc.

Sometimes it's easier to 'define' or 'describe' the output object than building it
by manipulating the input. The [`core.literal`](./stdlib/core/literal.md) let's you
do that with great power.

In its simplest form, `core.literal` produces its `defn` option as output. For
instance, the following program:

```yaml
---
core.literal:
  defn:
    hello: world
```

will produce the object `{"hello": "world"}` as output (in json notation here).

(Simplified) JSONPath expressions can be used to insert data from the input into
the output. As a simple example, the following program:

```yaml
---
core.literal:
  defn:
    hello: $.name
    version: $.versions[-1]
```

will produce the object `{"hello": "Monolens", "versions": 0.6}` as output if
`{"name": "Monolens", "versions": [0.5, 0.6]}` is provided as input.

JSONPath can also be used for interpolating strings. For instance the following
program:

```yaml
---
core.literal:
  defn:
    say: Hello $.name
```

will produce the object `{"say": "Hello Monolens"}` on the same input.

Make sure to ready about [simplified JSONPath](./3-simplified-jsonpath.md)
since Monolens (currently) expose limitations to keep the language secure.

## Going further

Here are some suggestions to keep reading:

- [Explore the standard library](./stdlib)
- [Explore the documented examples][./examples]
- [TODO: Using the commandline tool](./2-command-line.md)
- [TODO: Learn about simplified jsonpath](./3-simplified-jsonpath.md)
- [TODO: Read about how Macros help reusing code](./4-macros.md)
- [TODO: Build robust transformations with error handling](./5-error-handling.md)
