push!(LOAD_PATH,"../src/")
using Documenter, ParameterTests

makedocs(
    modules = [ParameterTests, IterTools],
    clean = false,
    format = Documenter.HTML(),
    sitename = "ParameterTests.jl",
    authors = "Iain Skett",
    pages = [
        "Introduction" => "index.md"
        "Getting Started" => "getting_started.md"
    ],
)

deploydocs(
    repo = "github.com/InfiniteChai/ParameterTests.jl.git"
)
