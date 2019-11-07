# src/conversion.jl
# Convert Rationals into other Numeral Types

import Base: convert, Bool, float, AbstractFloat, big, trunc, floor, ceil, round, promote_rule


"""```
convert(R::Type{<:AbstractRatio}, x::AbstractRatio)
    === build_ratio(R, x)
```
Convert an abstract ratio into another one through the generic construction.
"""
function convert(R::Type{<:AbstractRatio}, x::AbstractRatio)
    return build_ratio(R, x)
end


"""```
convert(R::Type{<:AbstractRational}, x::AbstractRatio)
    === resolve(R, x)
```
Convert a ratio `x` to a rational through canonical resolution.
"""
function convert(R::Type{<:AbstractRational}, x::AbstractRatio)
    return resolve(R, x)
end


"""```
convert(::Type{BigFloat}, x::AbstractRatio)
    === BigFloat(numerator(x)) / denominator(x)
```
Convert a ratio `x` to a high precision `BigFloat`.
"""
function convert(::Type{BigFloat}, x::AbstractRatio)
    return BigFloat(numerator(x)) / denominator(x)
end


"""```
convert(::Type{T <: AbstractFloat}, x::AbstractRatio{S})
```
Convert a ratio `x` to an floating point type.
"""
function convert(::Type{T}, x::AbstractRatio{S}) where {T<:AbstractFloat,S}
    P = promote_type(T, S)
    return convert(T, convert(P, numerator(x)) / convert(P, denominator(x)))
end


"""```
convert(R::Type{<:AbstractRatio{T}}, n::Integer)
    === build_ratio(R, convert(T, n), one(T))
```
Convert an integer `n` into a ratio.
"""
function convert(R::Type{<:AbstractRatio{T}}, n::Integer) where {T}
    return build_ratio(R, convert(T, n), one(T))
end


"""```
convert(R::Type{<:AbstractRatio{T}}, x::Rational)
    === build_ratio(R, convert(T, numerator(x)), convert(T, denominator(x)))
```
Convert a standard rational `x` to a ratio.
"""
function convert(R::Type{<:AbstractRatio{T}}, x::Rational) where {T}
    return build_ratio(R, convert(T, numerator(x)), convert(T, denominator(x)))
end


"""```
convert(::Type{Rational{T}}, x::AbstractRatio)
    === convert(T, numerator(x)) // convert(T, denominator(x))
```
Convert a ratio `x` to a standard rational.
"""
function convert(::Type{Rational{T}}, x::AbstractRatio) where {T}
    return convert(T, numerator(x)) // convert(T, denominator(x))
end


"""```
Bool(x::AbstractRatio)
```
Convert a ratio `x` to a boolean value.
"""
function Bool(x::AbstractRatio)
    return iszero(x) ? false : isone(x) ? true : throw(InexactError(:Bool, Bool, x))
end


"""```
float(::Type{<:AbstractRatio{T}})
    === float(T)
```
Return the floating point type for the underlying integer type of a ratio.
"""
float(::Type{<:AbstractRatio{T}}) where {T} = float(T)


"""```
AbstractFloat(x::AbstractRatio)
    === float(numerator(x)) / float(denominator(x))
```
Convert a ratio `x` to an abstract floating point number.
"""
AbstractFloat(x::AbstractRatio) = float(numerator(x)) / float(denominator(x))


"""```
big(x::AbstractRatio)
    === build_ratio(typeof(x), big.(numden(x))...)
```
Convert a ratio `x` into a high-precision `big` ratio.
"""
big(x::AbstractRatio) = build_ratio(typeof(x), big.(numden(x))...)


"""```
trunc(::Type{T}, x::AbstractRatio)
    === convert(T, div(numden(x)...))
```
Truncate a ratio `x` to the integer type `T`.
"""
trunc(::Type{T}, x::AbstractRatio) where {T} = convert(T, div(numden(x)...))


"""```
trunc(x::AbstractRatio{T})
    === build_ratio(typeof(x), trunc(T, x))
```
Truncate a ratio `x` at the nearest integer.
"""
trunc(x::AbstractRatio{T}) where {T} = build_ratio(typeof(x), trunc(T, x))


"""```
floor(::Type{T}, x::AbstractRatio)
    === convert(T, fld(numden(x)...))
```
Round a ratio `x` to the highest integer of type `T` less than or equal to `x`.
"""
floor(::Type{T}, x::AbstractRatio) where {T} = convert(T, fld(numden(x)...))


"""```
floor(x::AbstractRatio{T})
    === build_ratio(typeof(x), floor(T, x))
```
Round a ratio `x` to the highest integer less than or equal to `x`.
"""
floor(x::AbstractRatio{T}) where {T} = build_ratio(typeof(x), floor(T, x))


"""```
ceil(::Type{T}, x::AbstractRatio)
    === convert(T, cld(numden(x)...))
```
Round a ratio `x` to the least integer of type `T` greater than or equal to `x`.
"""
ceil(::Type{T}, x::AbstractRatio) where {T} = convert(T, cld(numden(x)...))


"""```
ceil(x::AbstractRatio{T})
    === build_ratio(typeof(x), ceil(T, x))
```
Round a ratio `x` to the least integer greater than or equal to `x`.
"""
ceil(x::AbstractRatio{T}) where {T} = build_ratio(typeof(x), ceil(T, x))


"""```
round(::Type{T}, x::AbstractRational, r::RoundingMode = RoundNearest)
```
Round a rational `x` according to the rounding mode `r`.
"""
function round(::Type{T}, x::AbstractRational, r::RoundingMode = RoundNearest) where {T}
    return _round_rational(T, x, r)
end


"""```
round(::Type{T}, x::AbstractRatio{Bool})
```
Round a boolean ratio `x` to an integer of type `T`.
"""
function round(::Type{T}, x::AbstractRatio{Bool}, ::RoundingMode = RoundNearest) where {T}
    if denominator(x) == false && T <: Integer
        throw(DivideError())
    end
    return convert(T, x)
end


"""```
round(x::AbstractRatio, r::RoundingMode)
    === round(typeof(x), x, r)
```
Round the ratio `x` to the integer determined by the rounding mode `r`.
"""
round(x::AbstractRatio, r::RoundingMode) = round(typeof(x), x, r)


"""```
round(x::AbstractRatio{T})
    === build_ratio(typeof(x), round(T, x))
```
Round the ratio `x` to the nearest integer.
"""
round(x::AbstractRatio{T}) where {T} = build_ratio(typeof(x), round(T, x))


"""```
promote_rule(::Type{<:AbstractRatio{T}}, ::Type{S<:AbstractFloat})
    === promote_type(T, S)
```
Return promotion rule for ratios to abstract floats.
"""
function promote_rule(::Type{<:AbstractRatio{T}}, ::Type{S}) where {T,S<:AbstractFloat}
    return promote_type(T, S)
end


"""```
promote_rule(::Type{<:AbstractRatio{T}}, ::Type{Rational{S}})
    === Rational{promote_type(T, S)}
```
Return promotion rule for ratios to standard rationals.
"""
function promote_rule(::Type{<:AbstractRatio{T}}, ::Type{Rational{S}}) where {T,S}
    return Rational{promote_type(T, S)}
end
