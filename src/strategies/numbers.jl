using Random: bitrand
struct IntegerStrategy{I<:Integer} <: SearchStrategy
    min::I
    max::I

    IntegerStrategy{I}(min::Nothing, max::Nothing) where {I<:Integer} = new{I}(typemin(I), typemax(I))
    IntegerStrategy{I}(min::Nothing, max) where {I<:Integer} = new{I}(typemin(I), max)
    IntegerStrategy{I}(min, max::Nothing) where {I<:Integer} = new{I}(min, typemax(I))
    function IntegerStrategy{I}(min, max) where {I<:Integer}
        min <= max || error("IntegerStrategy must have satisfiable bounds")
        new{I}(min, max)
    end
end

integers(; min=nothing, max=nothing) = IntegerStrategy{Int}(min, max)
integers(::Type{I}; min=nothing, max=nothing) where {I<:Integer} = IntegerStrategy{I}(min, max)

draw(strategy::IntegerStrategy{I}) where {I<:Integer} = rand(strategy.min:strategy.max)
Base.eltype(::IntegerStrategy{I}) where {I<:Integer} = I

struct BoundedFloatStrategy{F<:AbstractFloat} <: SearchStrategy
    min::F
    max::F

    BoundedFloatStrategy{F}(min, max) where {F<:AbstractFloat} = new{F}(min, max)
end


function draw(strategy::BoundedFloatStrategy{F}) where {F<:AbstractFloat}
    return strategy.min + (strategy.max - strategy.min)*rand(F)
end

Base.eltype(::BoundedFloatStrategy{F}) where {F<:AbstractFloat} = F

struct UnboundedFloatStrategy{F<:AbstractFloat} <: SearchStrategy
    allow_nan::Bool
    allow_inf::Bool

    UnboundedFloatStrategy{F}(allow_nan, allow_inf) where {F<:AbstractFloat} = new{F}(allow_nan, allow_inf)
end

UINTS_BY_SIZE = Dict(2=>UInt16,4=>UInt32,8=>UInt64)

function draw(strategy::UnboundedFloatStrategy{F}) where {F<:AbstractFloat}
    while true
        bits = replace(bitstring(bitrand(F.size*8))," "=>"")
        float = reinterpret(F, parse(UINTS_BY_SIZE[F.size], bits, base=2))
        isinf(float) && !strategy.allow_inf && continue
        isnan(float) && !strategy.allow_nan && !strategy.allow_inf && continue
        # It's highly likely that we'll select a NaN, so more evenly divide them
        # with infinite handling if we support that.
        if isnan(float) && strategy.allow_inf
            if !strategy.allow_nan
                float = rand(Bool) ? F(Inf) : F(-Inf)
            else
                switch = rand()
                float = switch < 1//3 ? float : (switch < 2//3 ? F(Inf) : F(-Inf))
            end
        end
        return float
    end
end

floats(; min=nothing, max=nothing, allow_nan=false, allow_inf=false) = floats(Float64; min=min, max=max, allow_nan=allow_nan, allow_inf=allow_inf)
function floats(::Type{F}; min=nothing, max=nothing, allow_nan=false, allow_inf=false) where {F<:AbstractFloat}
    min === nothing && max !== nothing && error("min/max must either both be defined or not at all")
    min !== nothing && max === nothing && error("min/max must either both be defined or not at all")
    min !== nothing && allow_nan && error("NaN not supported by bounded float strategy")
    min !== nothing && allow_inf && error("Inf not supported by bounded float strategy")

    min !== nothing && return BoundedFloatStrategy{F}(min, max)
    return UnboundedFloatStrategy{F}(allow_nan, allow_inf)
end

Base.eltype(::UnboundedFloatStrategy{F}) where {F<:AbstractFloat} = F
