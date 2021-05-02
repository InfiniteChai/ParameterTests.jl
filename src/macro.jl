is_given_macro(::Any) = false
is_given_macro(e::Expr) = e.head == :macrocall && e.args[1] == Symbol("@given")

given_parameters(::Any) = []
function given_parameters(e::Expr)
    if e.head == :call && e.args[1] == :∈
        # The name and associated iterator generator.
        return [(e.args[2], e.args[3])]
    elseif e.head == :tuple || is_given_macro(e)
        return vcat(map(given_parameters, e.args)...)
    end

    error("Cannot parse given parameters from expression $(e)")
end

function settingexpr(blocks::Expr...)
    call = Expr(:call, Expr(:., :ParameterTests, :(:ParamTestSettings)))
    params = Expr(:parameters, [Expr(:kw, block.args...) for block in blocks]...)
    push!(call.args, params)
    return call
end

macro paramtest(name::String, blocks::Expr...)
    block = blocks[end]
    block.head == :block || error("paramtest requires a block expression")
    givenlines = filter(is_given_macro, block.args)
    length(givenlines) > 0 || error("paramtest must have a @given parameters")
    # Drop the given lines from our block, we don't need them.
    filter!((!)∘is_given_macro, block.args)
    givenparams = vcat(map(given_parameters, givenlines)...)

    settings = settingexpr(blocks[1:end-1]...)
    testblock = quote
        @testset $name begin
            @testset ParameterTestSet begin
                ParameterTests.withsettings($settings) do
                    for $(Expr(:tuple, map(first, givenparams)...)) in $(Expr(:call, :zip, map(last, givenparams)...))
                        @testset SingleParameterTestSet begin
                            local ts = Test.get_testset()
                            $(map(p -> :(ts.parameters[$(QuoteNode(p))] = $p), map(first, givenparams))...)
                            $block
                        end
                    end
                end
            end
        end
    end
    return esc(testblock)
end
