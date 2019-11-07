# src/rounding.jl
# Generic Rounding Protocols


"""```
```
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
```
"""
function _round_rational(
    ::Type{T},
    x::AbstractRational{Tr},
    ::RoundingMode{:Nearest},
) where {T,Tr}
    return _round_rational_internal(T, x, (_, q) -> iseven(q))
end


"""```
```
"""
function _round_rational(
    ::Type{T},
    x::AbstractRational{Tr},
    ::RoundingMode{:NearestTiesAway},
) where {T,Tr}
    return _round_rational_internal(T, x, (_, q) -> zero(q))
end


"""```
```
"""
function _round_rational(
    ::Type{T},
    x::AbstractRational{Tr},
    ::RoundingMode{:NearestTiesUp},
) where {T,Tr}
    return _round_rational_internal(T, x, (x, q) -> numerator(x) < zero(q))
end


"""```
```
"""
function round(::Type{T}, x::AbstractRational{Bool}, ::RoundingMode = RoundNearest) where {T}
    if denominator(x) == false && (T <: Union{Integer,Bool})
        throw(DivideError())
    end
    return convert(T, x)
end
