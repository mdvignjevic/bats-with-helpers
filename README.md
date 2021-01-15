# bats-with-helpers

> Docker image that contains bats-core testing system and bats test helpers

[![NPM Version][npm-image]][npm-url]
[![Downloads Stats][npm-downloads]][npm-url]

Bats is a TAP-compliant testing framework for Bash. It provides a simple way to verify that the UNIX programs you write behave as expected.
A Bats test file is a Bash script with special syntax for defining test cases. Under the hood, each test case is just a function with a description.
<https://github.com/bats-core/bats-core>

**TODO**: Add assertions to excercise each bats helper included

## Usage example

- Run bats tests using pretty (default with tty allocated) formatter:

```bash
docker run -t -v "${PWD}:/code" mvignjevic/bats-with-helpers ./tests/test-example.bats
```

- Run bats tests using tap (default without tty) formatter:

```bash
docker run -v "${PWD}:/code" mvignjevic/bats-with-helpers ./tests/test-example.bats
```

- Run the container with the interactive shell for debugging:

```bash
docker run --rm -it -v ${PWD}:/code --entrypoint /bin/sh mvignjevic/bats-with-helpers
```

## Release History

- 1.0.0
  - The first proper release
  - CHANGE: Rename `foo()` to `bar()`
- 0.1.0
  - Work in progress

## Meta

Milan Vignjevic – panta5555@gmail.com

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/panta5/bats-with-helpers](https://github.com/panta5/bats-with-helpers)

<!-- Markdown link & img dfn's -->
[npm-image]: https://img.shields.io/npm/v/datadog-metrics.svg?style=flat-square
[npm-url]: https://npmjs.org/package/datadog-metrics
[npm-downloads]: https://img.shields.io/npm/dm/datadog-metrics.svg?style=flat-square
