using Dates: Date, UTInstant, Day

struct DateStrategy <: SearchStrategy
    min::Date
    max::Date

    DateStrategy(min::Nothing, max::Nothing) = new(Date(1,1,1), Date(9999,12,31))
    DateStrategy(min::Nothing, max::Date) = new(Date(1,1,1), max)
    DateStrategy(min::Date, max::Nothing) = new(min, Date(9999,12,31))
    function DateStrategy(min::Date, max::Date)
        min <= max || error("DateStrategy has unsatisfiable bounds")
        new(min, max)
    end
end

function draw(strategy::DateStrategy)
    days = rand(strategy.min.instant.periods.value:strategy.max.instant.periods.value)
    Date(UTInstant(Day(days)))
end

dates(; min=nothing, max=nothing) = DateStrategy(min, max)
Base.eltype(::DateStrategy) = Date
