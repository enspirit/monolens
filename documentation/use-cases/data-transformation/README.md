# Use case: Data transformation

This example shows how to transform data files using simple lenses. We take an
example with [DbAgent](https://github.com/enspirit/dbagent) (that makes heavy
use of .json data files), but remember that it's just about  data. You don't
have to master DbAgent to understand the usage of Monolens made here.

- [Introduction](#introduction)
  - [Database seed files](#database-seed-files)
  - [Then comes a database migration...](#then-comes-a-database-migration)
- [Migrating a single file](#migrating-a-single-file)
  - [Removing an object key](#removing-an-object-key)
  - [Mapping country names to their ISO codes](#mapping-country-names-to-their-iso-codes)
  - [Lenses compose](#lenses-compose)

## Introduction

[DbAgent](https://github.com/enspirit/dbagent) is a simple library and
[docker component](https://hub.docker.com/r/enspirit/dbagent) that allows
managing the lifecycle of (Postgre)SQL databases, such as running
migrations, taking a read-eval-print-loop, making backups, etc.

### Database seed files

Among available features, DbAgent allows filling the database from .json
files, as well as dumping its content as .json files. These files are called
seeds and are typically used to install a controlled initial system state before
running an automated test case.

Say for instance that the database has a `companies` table, where each company
has an id, a name, email of contact, and a country. The following file could be
a seed for that table:

```json
// companies.json
[
  {
    "id": 1,
    "name": "Enspirit SRL",
    "email": "info@enspirit.be",
    "country": "Belgium"
  },
  {
    "id": 2,
    "name": "Klaro Cards",
    "email": "info@enspirit.be",
    "country": "Belgium"
  },
  {
    "id": 3,
    "name": "Quadrabee",
    "email": "info@quadrabee.com",
    "country": "Spain"
  }
]
```

In practice, we have one such file for each table, and possibly different test
suites. That's a lot of data files to maintain...

### Then comes a database migration...

Let's say that the database schema evolves: we no longer need the email address
(maybe it was moved somewhere else) and want the country field to be an ISO code
instead of a full country name.

Our task is to automate the migration of the seed files, because we have 50 of
them (say).

## Migrating a single file

Migrating a single file is easy: we just need to remove a field and convert an
other one. Two lenses will be used: `object.allbut` (that keeps all but the
specified keys of its input object) and `object.transform` (that allows
modifying some key-value pairs).

### Removing an object key

Let's start with the first task, removing the email. The following program
is all we need:

```yaml
--- # allbut-email.lens.yml
object.allbut:
  defn:
  - email
```

Indeed, the following command will correctly migrate our companies...

```sh
monolens -m --json --pretty allbut-email.lens.yml companies.json
```

... the email has been thrown away as expected:

```json
[
  {
    "id": 1,
    "name": "Enspirit SRL",
    "country": "Belgium"
  },
  {
    "id": 2,
    "name": "Klaro Cards",
    "country": "Belgium"
  },
  {
    "id": 3,
    "name": "Quadrabee",
    "country": "Spain"
  }
]
```

You can't replace the original file by piping `> companies.json` in your shell
because this would override the input file before processing it. The `monolens`
commandline has a `--override` option to overcome this. So the following command
will replace the original file with the transformed data:

```sh
monolens --map --json --pretty --override allbut-email.lens.yml companies.json
```

Some magic hides behind the `--map` option. The option simply embeds our program
(that converts a single object) into an `array.map` (that loops over an input
array).

### Mapping country names to their ISO codes

The second task is to migrate the `country` field, by replacing full country
names by their ISO codes. We only handle a few countries below, but you get the
idea:

```yaml
--- # transform-country.lens.yml
object.transform:
  defn:
    country:
    - core.mapping:
        defn:
          Belgium: BE
          Spain: ES
          United Kingdom: UK
          France: FR
```

Let's try it out:

```shell
monolens --map --json --pretty transform-country.lens.yml companies.json
```

It works!

```json
[
  {
    "id": 1,
    "name": "Enspirit SRL",
    "email": "info@enspirit.be",
    "country": "BE"
  },
  {
    "id": 2,
    "name": "Klaro Cards",
    "email": "info@enspirit.be",
    "country": "BE"
  },
  {
    "id": 3,
    "name": "Quadrabee",
    "email": "info@quadrabee.com",
    "country": "ES"
  }
]
```

### Lenses compose

If you are a *nix user, you know that a pipe is all we need to apply each
transformation in turn. The `--stdin` option comes handy here:

```shell
monolens -mjp allbut-email.lens.yml companies.json | monolens -mjp --stdin transform-country.lens.yml
```

will give the following result:

```json
[
  {
    "id": 1,
    "name": "Enspirit SRL",
    "country": "BE"
  },
  {
    "id": 2,
    "name": "Klaro Cards",
    "country": "BE"
  },
  {
    "id": 3,
    "name": "Quadrabee",
    "country": "ES"
  }
]
```

This is a simple proof that lenses compose. Another way to compose them is to
make a more complex program in the first place. This one will do:

```yaml
--- # transform.lens.yml
- object.allbut:
    defn:
    - email
- object.transform:
    defn:
      country:
      - core.mapping:
          defn:
            Belgium: BE
            Spain: ES
            United Kingdom: UK
            France: FR
```

That is, an array of lenses behaves like *nix pipes: the output of the first
lens is then sent as input of the next one. You can verify that the following
command has the desired effect on our companies:

```shell
monolens -mjp --override transform.lens.yml companies.json
```
