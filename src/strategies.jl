abstract type SearchStrategy end
draw(s::SearchStrategy) = error("draw not defined by $(s)")

function Base.iterate(strategy::SearchStrategy, state=nothing)
    state = state === nothing ? 0 : state
    #TODO: Remove hardcoded count
    state >= PARAM_TEST_SETTINGS.samples && return nothing
    return (draw(strategy), state + 1)
end

Base.eltype(::SearchStrategy) = Any
