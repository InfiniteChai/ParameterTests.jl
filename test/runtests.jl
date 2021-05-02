using Test
using ParameterTests
using Dates: Date

@testset "Parameter Tests" verbose=true begin
    @testset "Strategy Generators" verbose=true begin
        @paramtest "Integers" begin
            @given a ∈ integers(Int8)
            @given b ∈ integers(; min=0)
            @given c ∈ integers(Int32; min=-10, max=10)
            @given d ∈ integers(Int64; max=3)
            @test isa(a, Int8)
            @test isa(b, Int) && b >= 0
            @test isa(c, Int32) && -10 <= c <= 10
            @test isa(d, Int64) && d <= 3
        end

        @paramtest "Floats" begin
            @given a ∈ floats(Float16)
            @given b ∈ floats(Float16; min=0, max=1)
            @given c ∈ floats(; allow_nan=true, allow_inf=true)
            @given d ∈ floats(Float32; allow_nan=false, allow_inf=true)
            @test isa(a, Float16) && !isnan(a) && !isinf(a)
            @test isa(b, Float16) && 0 <= b <= 1
            @test isa(c, Float64)
            @test isa(d, Float32)
        end

        @paramtest "Dates" begin
            @given a ∈ dates()
            @given b ∈ dates(;min=Date(2020,1,1))
            @given c ∈ dates(;min=Date(2020,1,1), max=Date(2021,1,1))
            @given d ∈ dates(;max=Date(2020,1,1))
            @test isa(a, Date)
            @test isa(b, Date) && b >= Date(2020,1,1)
            @test isa(c, Date) && Date(2020,1,1) <= c <= Date(2021,1,1)
            @test isa(d, Date) && d <= Date(2020,1,1)
        end

        @paramtest "Strings" begin
            @given a ∈ strings(; minsize=0, maxsize=10)
            @given b ∈ strings(:alphanum; minsize=3000)
            @given c ∈ strings(['A','B']; maxsize=3)
            @test length(a) <= 10
            @test 3000 <= length(b) <= 5000
            @test length(c) <= 3 && Set(c) ⊆ ('A','B')
        end

        @paramtest "Symbols" begin
            @given a ∈ symbols(; minsize=0, maxsize=10)
            @given b ∈ symbols(:alphanum; minsize=3000)
            @given c ∈ symbols(['A','B']; maxsize=3)
            @test length(String(a)) <= 10 && isa(a, Symbol)
            @test 3000 <= length(String(b)) <= 5000
            @test length(String(c)) <= 3 && Set(String(c)) ⊆ ('A','B')
        end
    end

    @testset "Strategy Parameters" verbose=true begin
        # Simple demonstration that our sample testing works as expected.
        count = 0
        @paramtest "Samples" samples=500 begin
            @given a ∈ integers(), b ∈ integers()
            count += 1
            @test a + b == b + a
        end

        @test count == 500
    end

    @testset "Array Strategies" verbose=true begin
        @paramtest "Vectors" begin
            @given a ∈ vectors(integers(); maxsize=5)
            @given b ∈ vectors(dates(;min=Date(2020,1,1)); minsize=5, maxsize=10)
            @given c ∈ vectors(floats(); minsize=10)
            @given d ∈ vectors(floats(Float32;min=0, max=10))
            @given e ∈ vectors(strings(); maxsize=3)
            @given f ∈ vectors(symbols(); maxsize=3)
            @test isa(a, Vector{Int}) && length(a) <= 5
            @test isa(b, Vector{Date}) && 5 <= length(b) <= 10
            @test all(map(x -> x >= Date(2020,1,1), b))
            @test isa(c, Vector{Float64}) && length(c) >= 10
            @test isa(d, Vector{Float32})
            @test isa(e, Vector{String})
            @test isa(f, Vector{Symbol})
        end
    end

    @testset "Parameters" verbose=true begin
        # This provides a simple example of how we can select from a parameter list
        # rather than using sample strategies
        dataset = 1:5
        @paramtest "Data" begin
            @given x ∈ dataset
            @test x <= 5
        end
    end
end
