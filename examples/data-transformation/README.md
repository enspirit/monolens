# Use case: Data transformation

This example shows how to transform data files using simple lenses.
We take an example with [DbAgent](https://github.com/enspirit/dbagent)
(that makes heavy use of .json data files), but remember that it's just about 
data. You don't have to master DbAgent to understand the usage of Monolens
made here.

- [Introduction](#introduction)
  - [Database seed files](#database-seed-files)
  - [Then comes a database migration...](#then-comes-a-database-migration)
- [Migrating a single file](#migrating-a-single-file)

## Introduction

[DbAgent](https://github.com/enspirit/dbagent) is a simple library and
[docker component](https://hub.docker.com/r/enspirit/dbagent) that allows
managing the lifecycle of (Postgre)SQL databases, such as running
migrations, taking a repl, making backups, etc.

### Database seed files

Among available features, DbAgent allows filling the database from .json
files, as well as dumping the content as .json files. These files are called
seeds and are typically used to install a known initial system state before
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

Let's say that your database schema evolve: you no longer need the email address
(maybe it was moved somewhere else) and want the country field to be an ISO code
instead of a full country name.

Our task is to make that easy even if we have 50 files.

## Migrating a single file

Migrating a single file is quite easy: we just need to remove a field and
convert a new one. Two lenses will be used: `object.allbut` (that keeps all
but the specified keys) and `object.transform` (that allows modifying some
key-value pairs).

Let's start with a the first one with the following program:

```yaml
--- # allbut-email.lens.yml
object.allbut:
  defn:
  - email
```

You can use the following command to test it on our companies:

```sh
monolens -m --json --pretty allbut-email.lens.yml companies.json
```

You should obtain the result below ; the email has been thrown away as expected:

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
because this would override the input file. The `monolens` commandline has a
`--override` option to overcome this. So the following command with replace
the original file with the transformed data:

```sh
monolens -m --json --pretty --override allbut-email.lens.yml companies.json
```
