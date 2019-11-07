# src/core.jl
# Core Abstract Definitions

import Base: numerator,
             denominator,
             divgcd,
             iszero,
             isone,
             isinteger,
             iseven,
             isodd,
             isinf,
             isnan,
             decompose

export missing_api, AbstractRatio, AbstractRational, build_ratio, numden


"""```
missing_api(name, args...; kwargs...)
```
Throw an `ArgumentError` if the function with name `name` is not defined on
the given `args` and `kwargs`.
"""
function missing_api(name::Union{Symbol,AbstractString}, args...; kwargs...)
    throw(ArgumentError("`$name` is not defined for `$args, $kwargs`"))
end


"""```
AbstractRatio{T <: Integer} <: Real
```
Abstraction of generic ratios. Numerator and denominator need not be in canonical form.
"""
abstract type AbstractRatio{T<:Integer} <: Real end


"""```
AbstractRational{T} <: AbstractRatio{T}
```
Abstraction of generic rational numbers. Numerator and denominator must always be in canonical form.
"""
abstract type AbstractRational{T} <: AbstractRatio{T} end


"""```
build_ratio(R::Type{<:AbstractRatio}, num, den, args...; kwargs...)
```
Replacement for `R` ratio constructor which accepts two integers: `num` and `den`.
"""
function build_ratio(R::Type{<:AbstractRatio}, num::Integer, den::Integer, args...; kwargs...)::R
    missing_api("build_ratio", R, num, den, args...; kwargs...)
end


"""```
build_ratio(R::Type{<:AbstractRatio}, r::AbstractRatio, args...; kwargs...)
```
Replacement for `R` ratio constructor which accepts a preexisting ratio: `ratio`.
"""
function build_ratio(R::Type{<:AbstractRatio}, ratio::AbstractRatio, args...; kwargs...)::R
    missing_api("build_ratio", R, ratio, args...; kwargs...)
end


"""```
numerator(x::AbstractRatio)
```
Return the numerator of the ratio `x`.
"""
function numerator(x::AbstractRatio)
    missing_api("numerator", x)
end


"""```
denominator(x::AbstractRatio)
```
Return the denominator of the ratio `x`.
"""
function denominator(x::AbstractRatio)
    missing_api("denominator", x)
end


"""```
numden(x)
    === numerator(x), denominator(x)
```
Return the numerator and denominator of the ratio `x`.
"""
numden(x) = numerator(x), denominator(x)


"""```
crossterms(x, y; product = *)
    === product(numerator(x), denominator(y)), product(numerator(y), denominator(x))
```
Return the cross terms in the construction of the common denominator.
"""
function crossterms(x, y; product = *)
    return product(numerator(x), denominator(y)), product(numerator(y), denominator(x))
end


"""```
resolve(R::Type{<:AbstractRational}, x)
```
Resolve a ratio `x` into a rational number in canonical form with type `R`.
"""
function resolve(R::Type{<:AbstractRational}, x)::R
    num, den = numden(x)
    return build_ratio(R, (signbit(den) ? divgcd(-num, -den) : divgcd(num, den))...)
end


"""```
iszero(x::AbstractRatio)
    === iszero(numerator(x)) && !iszero(denominator(x))
```
Check if the ratio `x` is the zero ratio.
"""
iszero(x::AbstractRatio) = iszero(numerator(x)) && !iszero(denominator(x))


"""```
iszero(x::AbstractRational)
    === iszero(numerator(x))
```
Check if the rational `x` is the zero rational.
"""
iszero(x::AbstractRational) = iszero(numerator(x))


"""```
isone(x::AbstractRatio)
    === numerator(x) == denominator(x)
```
Check if the ratio `x` is the one ratio.
"""
isone(x::AbstractRatio) = numerator(x) == denominator(x)


"""```
isone(x::AbstractRational)
    === isone(numerator(x)) & isone(denominator(x))
```
Check if the rational `x` is the one rational.
"""
isone(x::AbstractRational) = isone(numerator(x)) & isone(denominator(x))


"""```
isinteger(x::AbstractRatio)
    === iszero(rem(numden(x)...))
```
Check if the ratio `x` is an integer.
"""
isinteger(x::AbstractRatio) = iszero(rem(numden(x)...))


"""```
isinteger(x::AbstractRational)
    === isone(denominator(x))
```
Check if the rational `x` is an integer.
"""
isinteger(x::AbstractRational) = isone(denominator(x))


"""```
iseven(x::AbstractRatio)
```
Check if the ratio `x` is an even integer.
"""
function iseven(x::AbstractRatio)
    d, r = divrem(numden(x)...)
    return iszero(r) && iseven(d)
end


"""```
iseven(x::AbstractRational)
    === isinteger(x) && iseven(numerator(x))
```
Check if the rational `x` is an even integer.
"""
function iseven(x::AbstractRational)
    return isinteger(x) && iseven(numerator(x))
end


"""```
isodd(x::AbstractRatio)
```
Check if the ratio `x` is an odd integer.
"""
function isodd(x::AbstractRatio)
    d, r = divrem(numden(x)...)
    return iszero(r) && isodd(d)
end


"""```
isodd(x::AbstractRational)
    === isinteger(x) && isodd(numerator(x))
```
Check if the rational `x` is an odd integer.
"""
function isodd(x::AbstractRational)
    return isinteger(x) && isodd(numerator(x))
end


"""```
isinf(x::AbstractRatio)
```
Check if the ratio `x` is infinite.
"""
function isinf(x::AbstractRatio)
    return iszero(denominator(x)) & !iszero(numerator(x))
end


"""```
isinf(::AbstractRational)
    === false
```
There are no infinite rationals.
"""
isinf(::AbstractRational) = false


"""```
isnan(x::AbstractRatio)
    === iszero(numerator(x)) & iszero(denominator(x))
```
Check if the ratio `x` is not a number.
"""
isnan(x::AbstractRatio) = all(iszero, numden(x))


"""```
isnan(::AbstractRational)
    === false
```
There are no rationals which are not numbers.
"""
isnan(::AbstractRational) = false


"""```
decompose(x::AbstractRatio)
    === numerator(x), zero(x), denominator(x)
```
Decompose the ratio `x`.
"""
decompose(x::AbstractRatio) = numerator(x), zero(x), denominator(x)
