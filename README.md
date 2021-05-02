# ParameterTests.jl

*Provides support for parameter and sample tests in Julia*

| **Documentation**                                                         | **Build Status**                                              |
|:-------------------------------------------------------------------------:|:-------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][travis-img]][travis-url] [![][codecov-img]][codecov-url] |

This package builds around the standard testing framework in Julia to allow for easy
extension for parameterised and sample testing, while not restricting the free-form
testing capabilities.

## Example

This package provides a simple way to write parameterised tests and to help find
the edge cases in your code.

```julia
using ParameterTests
@paramtest "Integers Commute" begin
  @given a ∈ integers(), b ∈ integers()
  @test a + b == b + a
end
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
