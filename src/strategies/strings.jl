struct StringStrategy <: SearchStrategy
    alphabet::Vector{Char}
    minsize::UInt32
    maxsize::UInt32

    StringStrategy(alphabet, minsize, maxsize) = new(alphabet, minsize, maxsize)
end

function draw(strategy::StringStrategy)
    length = rand(strategy.minsize:strategy.maxsize)
    return string(rand(strategy.alphabet, length)...)
end

Base.eltype(::StringStrategy) = String

strings(; minsize=0, maxsize=5000) = strings(:alpha; minsize=minsize, maxsize=maxsize)
strings(sym::Symbol; minsize=0, maxsize=5000) = strings(Val(sym); minsize=minsize, maxsize=maxsize)
strings(::Val{:alpha}; minsize=0, maxsize=5000) = StringStrategy(collect(Iterators.flatten(('A':'Z', 'a':'z'))), minsize, maxsize)
strings(::Val{:alphanum}; minsize=0, maxsize=5000) = StringStrategy(collect(Iterators.flatten(('0':'9', 'A':'Z', 'a':'z'))), minsize, maxsize)
strings(alphabet; minsize=0, maxsize=5000) = StringStrategy(alphabet, minsize, maxsize)

struct SymbolStrategy <: SearchStrategy
    alphabet::Vector{Char}
    minsize::UInt32
    maxsize::UInt32

    SymbolStrategy(alphabet, minsize, maxsize) = new(alphabet, minsize, maxsize)
end

function draw(strategy::SymbolStrategy)
    length = rand(strategy.minsize:strategy.maxsize)
    return Symbol(rand(strategy.alphabet, length)...)
end

Base.eltype(::SymbolStrategy) = Symbol

symbols(; minsize=0, maxsize=5000) = symbols(:alpha; minsize=minsize, maxsize=maxsize)
symbols(sym::Symbol; minsize=0, maxsize=5000) = symbols(Val(sym); minsize=minsize, maxsize=maxsize)
symbols(::Val{:alpha}; minsize=0, maxsize=5000) = SymbolStrategy(collect(Iterators.flatten(('A':'Z', 'a':'z'))), minsize, maxsize)
symbols(::Val{:alphanum}; minsize=0, maxsize=5000) = SymbolStrategy(collect(Iterators.flatten(('0':'9', 'A':'Z', 'a':'z'))), minsize, maxsize)
symbols(alphabet; minsize=0, maxsize=5000) = SymbolStrategy(alphabet, minsize, maxsize)
