# Getting Started

Let's now walk through an example to get started with your first parameter tests

## Encoding Example

Let's suppose we're writing a [run length encoding](https://en.wikipedia.org/wiki/Run-length_encoding) algorithm
and we want to test it out.

Our first attempt is going to take the [Rosetta Code](https://rosettacode.org/wiki/Run-length_encoding#Julia) implementation

```julia
using IterTools: groupby
encode(str::String) = collect((length(g), first(g)) for g in groupby(first, str))
decode(cod::Vector) = join(repeat("$l", n) for (n, l) in cod)
```

We now want to start writing some tests for this that will check the invariance of these functions. The invariant
we normally associate with these algorithms is that if you decode what you encoded, you get back the same value.

Let's give that a go with sample testing on strings

```julia
using Test
using ParameterTests

@paramtest "Decode Inverts Encode" begin
  @given s ∈ strings(:alphanum; maxsize=10)
  @test decode(encode(s)) == s
end
```

This test is calling a search strategy for alphanumeric strings (up to 10 characters in length by default).
If we run this, we'll see that we've now sampled from 100 strings and all pass.
```
Test Summary:         | Pass  Total
Decode Inverts Encode |  100    100
```

So let's introduce a bug to our decode method.
```julia
decode(cod::Vector) = join(repeat("$l", n+1) for (n, l) in cod)
```
Then let's rerun our tests. We now see that only 13 of the 100 samples are actually passing, which
is for those with an empty string.

For the failed samples, we also print out details on the parameters and the test that failed. We see
that our string of `qNu` is an example failure, since we're decoding this back to `qqNNuu`!

```
Decode Inverts Encode: [s=qNu]
Test Failed at none:5
  Expression: decode(encode(s)) == s
   Evaluated: "qqNNuu" == "qNu"
Test Summary:         | Pass  Fail  Total
Decode Inverts Encode |   13    87    100
ERROR: Some tests did not pass: 13 passed, 87 failed, 0 errored, 0 broke
```

Note that your results may differ since we are randomly sampling, based on the seed set by `Test`.

## Sampling Multiple Variables
We do not restrict to a single sample set. You can join these together as required, so to sample two
independent integers we can run the following
```julia
@paramtest "Multiple Variables" begin
  @given a ∈ integers(), b ∈ integers()
  @test a + b == b + a
end
```

This is equivalent to writing them on two separate lines as follows.
```julia
@paramtest "Multiple Variables" begin
  @given a ∈ integers()
  @given b ∈ integers()
  @test a + b == b + a
end
```

While it is also possible to put the `@given` statements anywhere within the block (due to how we define them)
we recommend *NOT* doing the following and defining them at the top of your test set.
```julia
@paramtest "Multiple Variables" begin
  @test a + b == b + a
  @given a ∈ integers()
  @given b ∈ integers()
end
```

## Parameter Settings

Depending on what your testing, it can be useful to control the settings of parameter. These are exposed
via the `ParamTestSettings` structure and can be set in the `@paramtest` macro. For example, to set the
number of random samples to 500 we can just do this

```julia
@paramtest "Samples" samples=500 begin
    @given a ∈ integers(), b ∈ integers()  
    @test a + b == b + a
end
```

## Parameter Testing

While the sampling functions are very useful, this package also provides basic parameter testing.
That means that you can run the same test over different parameters and report the results. This
works in a similar fashion to sampling, except its restricted to the parameters you define.

As an example, let's test our encode example on a few different explicit cases

```julia
@paramtest "Decode Inverts Encode" begin
  @given s ∈ ["","\n","a\na"]
  @test decode(encode(s)) == s
end
```

We just use iterators for our test cases, so we can also combine our specific examples with a sampling
set as well!

```julia
@paramtest "Decode Inverts Encode" begin
  @given s ∈ Iterators.flatten((["", "\n", "a\nb"], strings(:alphanum; maxsize=10)))
  @test decode(encode(s)) == s
end
```
