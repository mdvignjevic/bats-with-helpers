# bats-with-helpers

> Docker image that contains bats-core testing system and bats test helpers

[![License](https://img.shields.io/github/license/panta5/bats-with-helpers.svg)](https://github.com/panta5/bats-with-helpers/blob/master/LICENSE)
[![Actions Status](https://github.com/panta5/bats-with-helpers/workflows/CI%20to%20Docker%20hub/badge.svg?branch=v1.0.0)](https://github.com/panta5/bats-with-helpers/actions)

Bats is a TAP-compliant testing framework for Bash. It provides a simple way to verify that the UNIX programs you write behave as expected.
A Bats test file is a Bash script with special syntax for defining test cases. Under the hood, each test case is just a function with a description.
<https://github.com/bats-core/bats-core>

**TODO**: Add assertions to excercise each bats helper included

## Usage example

- Run bats tests using pretty (default with tty allocated) formatter:

```bash
docker run --rm -t -v "${PWD}:/code" mvignjevic/bats-with-helpers ./tests/test-example.bats
```

- Run bats tests using tap (default without tty) formatter:

```bash
docker run --rm -v "${PWD}:/code" mvignjevic/bats-with-helpers ./tests/test-example.bats
```

- Run the container with the interactive shell for debugging:

```bash
docker run --rm -it -v ${PWD}:/code --entrypoint /bin/sh mvignjevic/bats-with-helpers
```

## Version history

- 1.0.0
  - The first proper release.

## Meta

Milan Vignjevic

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/panta5/bats-with-helpers](https://github.com/panta5/bats-with-helpers)

[licence-url]: https://github.com/panta5/bats-with-helpers/blob/master/LICENSE
[actions-url]: https://github.com/panta5/bats-with-helpers/actions
