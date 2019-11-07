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

export AbstractRatio, AbstractRational, build_ratio, numden


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
```
"""
abstract type AbstractRatio{T<:Integer} <: Real end


"""```
```
"""
abstract type AbstractRational{T} <: AbstractRatio{T} end


"""```
```
"""
function build_ratio(R::Type{<:AbstractRatio}, n::Integer, d::Integer, args...; kwargs...)::R
    missing_api("build_ratio", R, n, d, args...; kwargs...)
end


"""```
```
"""
function build_ratio(R::Type{<:AbstractRatio}, r::AbstractRatio, args...; kwargs...)::R
    missing_api("build_ratio", R, r, args...; kwargs...)
end


"""```
```
"""
function numerator(x::AbstractRatio)
    missing_api("numerator", x)
end


"""```
```
"""
function denominator(x::AbstractRatio)
    missing_api("denominator", x)
end


"""```
```
"""
numden(x) = numerator(x), denominator(x)


"""```
```
"""
function crossterms(x, y; product = *)
    return product(numerator(x), denominator(y)), product(numerator(y), denominator(x))
end


"""```
```
"""
function resolve(R::Type{<:AbstractRational}, x)::R
    num, den = numden(x)
    return build_ratio(R, (signbit(den) ? divgcd(-num, -den) : divgcd(num, den))...)
end


"""```
```
"""
iszero(x::AbstractRatio) = iszero(numerator(x))


"""```
```
"""
isone(x::AbstractRatio) = numerator(x) == denominator(x)


"""```
```
"""
isone(x::AbstractRational) = isone(numerator(x)) & isone(denominator(x))


"""```
```
"""
isinteger(x::AbstractRatio) = iszero(rem(numden(x)...))


"""```
```
"""
isinteger(x::AbstractRational) = isone(denominator(x))


"""```
```
"""
function iseven(x::AbstractRatio)
    d, r = divrem(numden(x)...)
    return iszero(r) && iseven(d)
end


"""```
```
"""
function iseven(x::AbstractRational)
    return isinteger(x) && iseven(numerator(x))
end


"""```
```
"""
function isodd(x::AbstractRatio)
    d, r = divrem(numden(x)...)
    return iszero(r) && isodd(d)
end


"""```
```
"""
function isodd(x::AbstractRational)
    return isinteger(x) && isodd(numerator(x))
end


"""```
```
"""
function isinf(x::AbstractRatio)
    missing_api("isinf", x)
end


"""```
```
"""
isinf(x::AbstractRational) = false


"""```
```
"""
isnan(x::AbstractRatio) = false


"""```
```
"""
decompose(x::AbstractRatio) = numerator(x), zero(x), denominator(x)
