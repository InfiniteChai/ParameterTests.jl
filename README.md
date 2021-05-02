# ParameterTests.jl

*Provides support parameter and sample tests in Julia*

| **Documentation**                                                         | **Build Status**                                              |
|:-------------------------------------------------------------------------:|:-------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][travis-img]][travis-url] [![][codecov-img]][codecov-url] |

This package builds around the standard testing framework in Julia to allow for easy
extension for parameterised and sample testing, while not restricting the free-form
testing capabilities.

## Installation

ParameterTests can be installed via the Julia package manager. From the Julia REPL type `]` to
enter the Pkg REPL mode and run

```julia
pkg> add ParameterTests
```

Similarly to `Test` you will generally only want to have this as part of the testing packages
so it's worth editing your `Project.toml` to move the dependency to only be in extras

```toml
[extras]
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
ParameterTests = "8eb61621-d5fd-4192-a1eb-e9414570b645"

[targets]
test = ["Test", "ParameterTests"]
```

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://infinitechai.github.io/ParameterTests.jl/dev

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://infinitechai.github.io/ParameterTests.jl/stable

[travis-img]: https://travis-ci.com/InfiniteChai/ParameterTests.jl.svg?branch=main
[travis-url]: https://travis-ci.com/InfiniteChai/ParameterTests.jl

[codecov-img]: https://codecov.io/gh/InfiniteChai/ParameterTests.jl/branch/main/graph/badge.svg
[codecov-url]: https://codecov.io/gh/InfiniteChai/ParameterTests.jl

[issues-url]: https://github.com/JuliaDocs/Documenter.jl/issues
