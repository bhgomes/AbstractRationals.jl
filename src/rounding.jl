# src/rounding.jl
# Generic Rounding Protocols


"""```
_round_rational_internal(::Type{T}, x::AbstractRational{Tr}, inner_term)
```
Internal implementation of the rational rounding.
Adapted from Julia internals.
"""
function _round_rational_internal(::Type{T}, x::AbstractRational{Tr}, inner_term) where {T,Tr}
    if denominator(x) == zero(Tr) && T <: Integer
        throw(DivideError())
    elseif denominator(x) == zero(Tr)
        return convert(T, copysign(one(Tr) // zero(Tr), numerator(x)))
    end
    q, r = divrem(numden(x)...)
    s = q
    if abs(r) >= abs((denominator(x) - copysign(Tr(4), numerator(x)) + one(Tr) +
                      inner_term(x, q)) >> 1 + copysign(Tr(2), numerator(x)))
        s += copysign(one(Tr), numerator(x))
    end
    return convert(T, s)
end


"""```
_round_rational(::Type{T}, x::AbstractRational{Tr}, ::RoundingMode{:Nearest})
```
Internal implementation of the `Nearest` mode rational rounding.
Adapted from Julia internals.
"""
function _round_rational(
    ::Type{T},
    x::AbstractRational{Tr},
    ::RoundingMode{:Nearest},
) where {T,Tr}
    return _round_rational_internal(T, x, (_, q) -> iseven(q))
end


"""```
_round_rational(::Type{T}, x::AbstractRational{Tr}, ::RoundingMode{:NearestTiesAway})
```
Internal implementation of the `NearestTiesAway` mode rational rounding.
Adapted from Julia internals.
"""
function _round_rational(
    ::Type{T},
    x::AbstractRational{Tr},
    ::RoundingMode{:NearestTiesAway},
) where {T,Tr}
    return _round_rational_internal(T, x, (_, q) -> zero(q))
end


"""```
_round_rational(::Type{T}, x::AbstractRational{Tr}, ::RoundingMode{:NearestTiesUp})
```
Internal implementation of the `NearestTiesUp` mode rational rounding.
Adapted from Julia internals.
"""
function _round_rational(
    ::Type{T},
    x::AbstractRational{Tr},
    ::RoundingMode{:NearestTiesUp},
) where {T,Tr}
    return _round_rational_internal(T, x, (x, q) -> numerator(x) < zero(q))
end
