
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
