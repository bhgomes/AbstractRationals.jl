# src/arithmetic.jl
# Arithmetic of Rationals

import Base: sign,
             signbit,
             abs,
             abs2,
             copysign,
             flipsign,
             BitSigned,
             +,
             -,
             *,
             /,
             //,
             ^,
             inv,
             fma,
             power_by_squaring,
             div,
             checked_mul


"""```
```
"""
sign(x::AbstractRatio) = oftype(x, sign(numerator(x)))


"""```
```
"""
signbit(x::AbstractRatio) = signbit(numerator(x))


"""```
```
"""
abs(x::AbstractRatio) = signbit(x) ? -x : x


"""```
```
"""
abs2(x::AbstractRatio) = x * x


"""```
```
"""
copysign(x::AbstractRatio, y::Number) = signbit(y) ? -abs(x) : abs(x)


"""```
```
"""
flipsign(x::AbstractRatio, y::Number) = signbit(y) ? -x : x


"""```
```
"""
+(x::AbstractRatio) = build_ratio(typeof(x), +numerator(x), denominator(x))


"""```
```
"""
-(x::AbstractRatio) = build_ratio(typeof(x), -numerator(x), denominator(x))


"""```
```
"""
function -(x::AbstractRational{T}) where {T<:BitSigned}
    if numerator(x) == typemin(T)
        throw(OverflowError("rational numerator is typemin(T)"))
    end
    return build_ratio(typeof(x), -numerator(x), denominator(x))
end


"""```
```
"""
function -(x::AbstractRational{T}) where {T<:Unsigned}
    if numerator(x) != zero(T)
        throw(OverflowError("cannot negate unsigned number"))
    end
    return x
end


"""```
```
"""
function *(x::AbstractRational, y::AbstractRational)
    xn, yd = divgcd(numerator(x), denominator(y))
    xd, yn = divgcd(denominator(x), numerator(y))
    return build_ratio(typeof(x), checked_mul(xn, yn), checked_mul(xd, yd))
end


"""```
```
"""
function /(x::AbstractRational, y::AbstractRational)
    return build_ratio(typeof(x), numerator(x) * denominator(y), denominator(x) * numerator(y))
end


"""```
```
"""
function /(x::AbstractRational, y::Complex{<:Union{Integer,Rational}})
    return build_ratio(typeof(x), numerator(x) * denominator(y), denominator(x) * numerator(y))
end


"""```
```
"""
function //(x::AbstractRational, y)
    xn, yn = divgcd(numerator(x), y)
    return xn // checked_mul(x.den, yn)
end


"""```
```
"""
function //(x, y::AbstractRational)
    xn, yn = divgcd(x, numerator(y))
    return checked_mul(xn, denominator(y)) // yn
end


"""```
```
"""
function //(x::AbstractRational, y::AbstractRational)
    xn, yn = divgcd(numerator(x), numerator(y))
    xd, yd = divgcd(denominator(x), denominator(y))
    return checked_mul(xn, yd) // checked_mul(xd, yn)
end


"""```
```
"""
function ^(x::AbstractRatio, n::Integer)
    return n >= zero(n) ? power_by_squaring(x, n) : power_by_squaring(inv(x), -n)
end


"""```
```
"""
^(x::Number, y::AbstractRational) = x^(numerator(y) / denominator(y))


"""```
```
"""
^(x::T, y::AbstractRatio) where {T<:AbstractFloat} = x^convert(T, y)


"""```
```
"""
^(z::Complex{T}, p::AbstractRatio) where {T} = z^convert(typeof(one(T)^p), p)


"""```
```
"""
^(z::Complex{<:AbstractRatio}, n::Bool) = n ? z : one(z)


"""```
```
"""
function ^(z::Complex{<:AbstractRatio}, n::Integer)
    return n >= zero(n) ? power_by_squaring(z, n) : power_by_squaring(inv(z), -n)
end


"""```
```
"""
inv(x::AbstractRatio) = build_ratio(typeof(x), denominator(x), numerator(x))


"""```
```
"""
fma(x::AbstractRatio, y::AbstractRatio, z::AbstractRatio) = (x * y) + z


"""```
```
"""
function div(x::AbstractRational, y::Integer, r::RoundingMode)
    xn, yn = divgcd(numerator(x), y)
    return div(xn, checked_mul(denominator(x), yn), r)
end


"""```
```
"""
function div(x::Integer, y::AbstractRational, r::RoundingMode)
    xn, yn = divgcd(x, numerator(y))
    return div(checked_mul(xn, denominator(y)), yn, r)
end


"""```
```
"""
function div(x::AbstractRational, y::AbstractRational, r::RoundingMode)
    xn, yn = divgcd(numerator(x), numerator(y))
    xd, yd = divgcd(denominator(x), denominator(y))
    return div(checked_mul(xn, yd), checked_mul(xd, yn), r)
end


"""```
```
"""
div(x::AbstractRatio, y) = div(x, y, RoundToZero)


"""```
```
"""
fld(x::AbstractRatio, y) = div(x, y, RoundDown)


"""```
```
"""
cld(x::AbstractRatio, y) = div(x, y, RoundUp)


"""```
```
"""
div(x, y::AbstractRatio) = div(x, y, RoundToZero)


"""```
```
"""
fld(x, y::AbstractRatio) = div(x, y, RoundDown)


"""```
```
"""
cld(x, y::AbstractRatio) = div(x, y, RoundUp)


"""```
```
"""
div(x::AbstractRatio, y::AbstractRatio) = div(x, y, RoundToZero)


"""```
```
"""
fld(x::AbstractRatio, y::AbstractRatio) = div(x, y, RoundDown)


"""```
```
"""
cld(x::AbstractRatio, y::AbstractRatio) = div(x, y, RoundUp)
