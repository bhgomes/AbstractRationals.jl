# src/arithmetic.jl
# Arithmetic of Rationals

import Base: sign, signbit, BitSigned, copysign, abs, inv, fma, +, -, *, /, //, ^, div, trunc, floor, ceil, round


"""
"""
sign(x::AbstractRational) = oftype(x, sign(numerator(x)))


"""
"""
signbit(x::AbstractRational) = signbit(numerator(x))


"""
"""
+(x::AbstractRational) = build_rational(typeof(x), +numerator(x), denominator(x))


"""
"""
-(x::AbstractRational) = build_rational(typeof(x), -numerator(x), denominator(x))


"""
"""
function -(x::AbstractRational{T}) where {T<:BitSigned}
    numerator(x) == typemin(T) && throw(OverflowError("rational numerator is typemin(T)"))
    return build_rational(typeof(x), -numerator(x), denominator(x))
end


"""
"""
function -(x::AbstractRational{T}) where T<:Unsigned
    numerator(x) != zero(T) && throw(OverflowError("cannot negate unsigned number"))
    return x
end


"""
"""
function *(x::Rational, y::Rational)
    xn, yd = divgcd(x.num, y.den)
    xd, yn = divgcd(x.den, y.num)
    return build_rational(typeof(x), checked_mul(xn,yn), checked_mul(xd,yd))
end


"""
"""
function /(x::Rational, y::Rational)
    return build_rational(typeof(x), numerator(x)*denominator(y), denominator(x)*numerator(y))
end


"""
"""
function /(x::Rational, y::Complex{<:Union{Integer,Rational}})
    return build_rational(typeof(x), numerator(x)*denominator(y), denominator(x)*numerator(y))
end


"""
"""
inv(x::AbstractRational) = build_rational(typeof(x), denominator(x), numerator(x))


"""
"""
fma(x::AbstractRational, y::AbstractRational, z::AbstractRational) = (x * y) + z


"""
"""
^(x::Number, y::AbstractRational) = x^(numerator(y) / denominator(y))


"""
"""
^(x::T, y::AbstractRational) where {T<:AbstractFloat} = x^convert(T, y)


"""
"""
^(z::Complex{T}, p::AbstractRational) where {T<:Real} = z^convert(typeof(one(T)^p), p)


"""
"""
^(z::Complex{<:AbstractRational}, n::Bool) = n ? z : one(z)
