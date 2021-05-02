module ParameterTests

include("testsets.jl")
include("macro.jl")
include("strategies.jl")

# Now include the various strategies we have
include("strategies/numbers.jl")
include("strategies/dates.jl")
include("strategies/arrays.jl")
include("strategies/strings.jl")

export @paramtest, SingleParameterTestSet, ParameterTestSet
export integers, dates, vectors, floats, strings, symbols

end # module
