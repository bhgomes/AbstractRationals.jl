# src/conversion.jl
# Convert Rationals into other Numeral Types

import Base: convert,
             Bool,
             float,
             AbstractFloat,
             big,
             trunc,
             floor,
             ceil,
             round,
             promote_rule


"""```
```
"""
function convert(R::Type{<:AbstractRatio}, x::AbstractRatio)
    return build_ratio(R, numden(x)...)
end


"""```
```
"""
function convert(R::Type{<:AbstractRational}, x::AbstractRatio)
    return resolve(R, x)
end


"""```
```
"""
convert(::Type{BigFloat}, x::AbstractRatio) = BigFloat(numerator(x)) / denominator(x)


"""```
```
"""
function convert(::Type{T}, x::AbstractRatio{S}) where {T<:AbstractFloat,S}
    P = promote_type(T, S)
    return convert(T, convert(P, numerator(x)) / convert(P, denominator(x)))
end


"""```
```
"""
convert(R::Type{<:AbstractRatio{T}}, n::Integer) where {T<:Integer} =
    build_ratio(R, convert(T, n), one(T))


"""```
```
"""
convert(R::Type{<:AbstractRatio{T}}, x::Rational) where {T} =
    build_ratio(R, convert(T, numerator(x)), convert(T, denominator(x)))


"""```
```
"""
convert(::Type{Rational{T}}, x::AbstractRatio) where {T} =
    convert(T, numerator(x)) // convert(T, denominator(x))


"""```
```
"""
function Bool(x::AbstractRational)
    return iszero(x) ? false : isone(x) ? true : throw(InexactError(:Bool, Bool, x))
end


"""```
```
"""
float(::Type{<:AbstractRatio{T}}) where {T} = float(T)


"""```
```
"""
AbstractFloat(x::AbstractRatio) = float(numerator(x)) / float(denominator(x))


"""```
```
"""
big(q::AbstractRatio) = build_ratio(typeof(q), big.(numden(q))...)


"""```
```
"""
trunc(::Type{T}, x::AbstractRational) where {T} = convert(T, div(numden(x)...))


"""```
```
"""
trunc(x::AbstractRatio{T}) where {T} = build_ratio(typeof(x), trunc(T, x))


"""```
```
"""
floor(::Type{T}, x::AbstractRational) where {T} = convert(T, fld(numden(x)...))


"""```
```
"""
floor(x::AbstractRatio{T}) where {T} = build_ratio(typeof(x), floor(T, x))


"""```
```
"""
ceil(::Type{T}, x::AbstractRational) where {T} = convert(T, cld(numden(x)...))


"""```
```
"""
ceil(x::AbstractRatio{T}) where {T} = build_ratio(typeof(x), ceil(T, x))


"""```
```
"""
function round(::Type{T}, x::AbstractRational, r::RoundingMode = RoundNearest) where {T}
    return _round_rational(T, x, r)
end


"""```
```
"""
round(x::AbstractRatio, r::RoundingMode) = round(typeof(x), x, r)


"""```
```
"""
round(x::AbstractRatio{T}) where {T} = build_ratio(typeof(x), round(T, x))


"""```
```
"""
function promote_rule(::Type{<:AbstractRational{T}}, ::Type{S}) where {T,S<:AbstractFloat}
    return promote_type(T, S)
end


"""```
```
"""
function promote_rule(::Type{<:AbstractRatio{T}}, ::Type{Rational{S}}) where {T,S}
    return Rational{promote_type(T, S)}
end
