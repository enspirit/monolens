# Use case: Data templates

This example shows how to instantiate data templates containing jsonpath
expressions with an input file. We take an example with Kubernetes (that makes
heavy use of .yaml configuration files), but remember that it's just about
data. You don't have to master Kubernetes to understand the usage of Monolens
made here.

- [Introduction](#introduction)
- [A single service first](#a-single-service-first)
  - [`monolens -l` - A shortcut over core.literal](#monolens--l---a-shortcut-over-coreliteral)
- [Multiple services](#multiple-services)
  - [`monolens -m` - A shortcut over array.map](#monolens--m---a-shortcut-over-arraymap)
- [For Kuberneters only (?)](#for-kuberneters-only)
  - [Generating multiple YAML documents](#generating-multiple-yaml-documents)
  - [A quick comparison with Helm](#a-quick-comparison-with-helm)

## Introduction

Let's say you want to deploy an app with Kubernetes. Kubernetes works with
.yaml files that describe the necessary cloud resources to manage. For instance,
the following file describes a Kubernetes Service...

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: monolens-sass-backend
spec:
  selector:
    app: Monolens-SASS
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

Kubernetes configuration files are rather verbose, and if you have two services
to deploy with similar configurations, you will have to create two files that
are vastly similar (expect maybe the service name, say).

We would like to describe the services we have with a much simpler configuration
and generate the Kubernetes resources from a shared template.

## A single service first

Let's start with only one service for now and get back to multiple services
later.

If only the name changes from one service to another, the simplest configuration
file could be as this:

```yaml
--- # single-service.input.yaml
name: monolens-sass-backend
```

A straightforward way to convert our original Service file to a template is to
replace the service name by a jsonpath expression:

```yaml
--- # single-service.tpl.yaml
apiVersion: v1
kind: Service
metadata:
  name: $.name
spec:
  selector:
    app: Monolens-SASS
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

The command to instantiate our service template is straightforward:

```shell
monolens -l --yaml single-service.tpl.yaml single-service.input.yaml
```

It's a bit magic though, thanks to the -l option. Let's see what happens under
the hood.

## `monolens -l` - A shortcut over core.literal

The `single-service.tpl.yaml` file is not a lens. Neither is it a *text*
template that you would create with Mustache or use in Helm. Here, it is a
*data* template. This kind of data template is taken by the `core.literal` lens
as option.

In fact `monolens -l` embeds the input data template to build then execute the
monolens program below. This "program" takes data as input and generates
instantiated data as output.

```yaml
--- # single-service.lens.yaml
core.literal:
  defn: 
    apiVersion: v1
    kind: Service
    metadata:
      name: $.name
    spec:
      selector:
        app: Monolens-SASS
      ports:
        - protocol: TCP
          port: 80
          targetPort: 8080
```

You can indeed verify that the following command (without the `-l` option) gives
the same output as the previous one:

```shell
monolens --yaml single-service.lens.yaml single-service.input.yaml
```

## Multiple services

Let's say we have multiple services to generate, and change our configuration
file to this:

```yaml
--- # multiple-services.input.yaml
- name: monolens-sass-backend
- name: monolens-sass-frontend
```

We would like to instantiate our template for each service. Let's use some
magic first, as before, and add the `-m` option to our original command
(warn: the order of `-l` and `-m` matters):

```shell
monolens -l -m --yaml single-service.tpl.yaml multiple-services.input.yaml
```

Here we go! We end up with a list of Service resources:

```yaml
---
- apiVersion: v1
  kind: Service
  metadata:
    name: monolens-sass-backend
  spec:
    selector:
      app: Monolens-SASS
    ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
- apiVersion: v1
  kind: Service
  metadata:
    name: monolens-sass-frontend
  spec:
    selector:
      app: Monolens-SASS
    ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

### `monolens -m` - A shortcut over array.map

While `-l` embeds the data template within a `core.literal`, `-m` embeds the
resulting lens into an `array.map` (that executes its `lenses` on each item
of the data input and collects the result as a new array). In other words, the
"program" we execute is the following one:

```yaml
--- # mutiple-services.lens.yaml
array.map:
  lenses:
    core.literal:
      defn: 
        apiVersion: v1
        kind: Service
        metadata:
          name: $.name
        spec:
          selector:
            app: Monolens-SASS
          ports:
            - protocol: TCP
              port: 80
              targetPort: 8080
```

Indeed, the following command yields the exact same result:

```shell
monolens -l -m --yaml multiple-services.lens.yaml multiple-service.input.yaml
```

## For Kuberneters only (?)

The output of our program is an array of Service configurations. Maybe you
are more used to multiple yaml documents. We've got you covered with the
`--stream` (aka `-s`) option.

### Generating multiple YAML documents

Our final (and most natural command) for the job at hand is:

```shell
monolens -lmsy single-service.tpl.yaml multiple-service.input.yaml
```

It correctly generates the following output, that can be fed into `kubectl`.

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: monolens-sass-backend
spec:
  selector:
    app: Monolens-SASS
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: monolens-sass-frontend
spec:
  selector:
    app: Monolens-SASS
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
```

### A quick comparison with Helm

If you know Helm, you probably wonder what are the similitudes and differences.
So here are a few ones:

* Heml templates are *text* templates, not valid *yaml* data. In contrast,
  Monolens templates are valid data. In fact they mix data capturing desired
  input/output and data that capture the program itself ; this is a property
  shared with other homoiconic languages, that Helm is not.

* Our approach outlined here is very limited in comparison to what Helm offers
  with respect to the lifecycle of Kubernetes resources. But speaking about
  the instantiation of templates specifically, we think that monolens is a
  promising approach, that could be easier to use than Helm.
