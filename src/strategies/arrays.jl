struct VectorStrategy <: SearchStrategy
    elements::SearchStrategy
    minsize::UInt
    maxsize::UInt

    VectorStrategy(elements::SearchStrategy, minsize::Nothing, maxsize::Nothing) = new(elements, 0, 9999)
    VectorStrategy(elements::SearchStrategy, minsize::Nothing, maxsize) = new(elements, 0, maxsize)
    VectorStrategy(elements::SearchStrategy, minsize, maxsize::Nothing) = new(elements, minsize, 9999)
    function VectorStrategy(elements::SearchStrategy, minsize, maxsize)
        minsize <= maxsize || error("VectorStrategy has unsatisfiable bounds")
        new(elements, minsize, maxsize)
    end
end

function draw(strategy::VectorStrategy)
    len = rand(strategy.minsize:strategy.maxsize)
    result = Base.eltype(strategy)()
    for _ in 1:len
        push!(result, draw(strategy.elements))
    end
    return result
end

vectors(elements::SearchStrategy; minsize=nothing, maxsize=nothing) = VectorStrategy(elements, minsize, maxsize)
Base.eltype(s::VectorStrategy) = Vector{Base.eltype(s.elements)}
