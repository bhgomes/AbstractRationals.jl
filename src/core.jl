# src/core.jl
# Core Abstract Definitions

import Base: numerator, denominator, isone, iszero, isinteger, decompose

export AbstractRational


"""```
missing_api(name, args...; kwargs...)
```
Throw an `ArgumentError` if the function with name `name` is not defined on
the given `args` and `kwargs`.
"""
function missing_api(name::Union{Symbol,AbstractString}, args...; kwargs...)
    throw(ArgumentError("`$name` is not defined for `$args, $kwargs`"))
end


"""
"""
abstract type AbstractRational{T <: Integer} <: Real end


"""
"""
function build_rational(R::Type{<:AbstractRational{T}}, n::T, d::T, args...; kwargs...) where {T}
    missing_api("build_rational", R, n, d, args...; kwargs...)
end


"""
"""
function numerator(x::AbstractRational)
    missing_api("numerator", x)
end


"""
"""
function denominator(x::AbstractRational)
    missing_api("denominator", x)
end


"""
"""
iszero(x::AbstractRational) = iszero(numerator(x))


"""
"""
isone(x::AbstractRational) = isone(numerator(x)) & isone(denominator(x))


"""
"""
isinteger(x::AbstractRational) = isone(denominator(x))


"""
"""
decompose(x::AbstractRational) = numerator(x), zero(x), denominator(x)
