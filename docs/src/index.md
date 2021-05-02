# Introduction

*Provides support parameter and sample tests in Julia*

This package aims to extend the standard testing components in Julia to support parameter
and sample testing and to cleanly integrate into the standard test outputs.

## Package Features
- A simple macro extension of `@testset` to support parameterised testing
- Integration into the test output so identify failed parameters
- Support for parameter strategies, to allow support for randomised sample testing

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
