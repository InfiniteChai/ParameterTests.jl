using Test: AbstractTestSet, @testset, @test
import Test

mutable struct SingleParameterTestSet <: AbstractTestSet
    parameters::Dict{Symbol,Any}
    results::Vector
    n_passed::Int

    SingleParameterTestSet(::String) = new(Dict(), [], 0)
end

mutable struct ParameterTestSet <: AbstractTestSet
    results::Vector
    ParameterTestSet(::String) = new([])
end

function quietrecord(ts::Test.DefaultTestSet, t::Union{Test.Fail, Test.Error}, pts::SingleParameterTestSet)
    if Test.TESTSET_PRINT_ENABLE[]
        params = join(["$k=$v" for (k,v) in pts.parameters], ",")
        Test.printstyled("$(ts.description): [$params]\n", color=:white)
        # don't print for interrupted tests
        if !(t isa Test.Error) || t.test_type !== :test_interrupted
            print(t)
            println()
        end
    end
    push!(ts.results, t)
    return t
end

function Test.finish(ts::ParameterTestSet)
    # We'll capture them all for the moment, but we probably need to wrap this a little bit with
    # the relevant parameters.
    parent_ts = Test.get_testset()
    parent_ts.n_passed = foldl(+, map(x -> x.n_passed, filter(x -> isa(x, SingleParameterTestSet), ts.results)); init=0)

    actualresults = filter(x -> !isa(x, SingleParameterTestSet), ts.results)
    if length(actualresults) > 0
        for result in actualresults
            Test.record(parent_ts, result)
        end
    else
        failedsets = filter(x -> length(x.results) > 0, ts.results)
        # We just detail errors from the first case.
        if length(failedsets) > 0
            for result in failedsets[1].results
                quietrecord(parent_ts, result, failedsets[1])
            end
            for set in failedsets[2:end]
                for result in set.results
                    push!(parent_ts.results, result)
                end
            end
        end
    end

    return ts
end

Test.record(ts::ParameterTestSet, t::SingleParameterTestSet) = (push!(ts.results, t); ts)
Test.record(ts::ParameterTestSet, t::Union{Test.Broken, Test.Fail, Test.Error}) = (push!(ts.results, t); ts)

Test.record(ts::SingleParameterTestSet, t::Union{Test.Broken, Test.Fail, Test.Error}) = (push!(ts.results, t); t)
Test.record(ts::SingleParameterTestSet, t::Test.Pass) = (ts.n_passed += 1; t)
function Test.finish(ts::SingleParameterTestSet)
    parent_ts = Test.get_testset()
    Test.record(parent_ts, ts)
    return ts
end

struct ParamTestSettings
    samples::Int

    ParamTestSettings(;samples=100) = new(samples)
end

PARAM_TEST_SETTINGS = nothing

function withsettings(f::Base.Callable, settings::ParamTestSettings)
    global PARAM_TEST_SETTINGS
    current = PARAM_TEST_SETTINGS
    try
        PARAM_TEST_SETTINGS = settings
        f()
    finally
        PARAM_TEST_SETTINGS = current
    end
end
