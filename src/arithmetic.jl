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
             fld,
             cld,
             checked_mul


"""```
sign(x::AbstractRational)
    === oftype(x, sign(numerator(x)))
```
Return the sign of the rational `x`.
"""
sign(x::AbstractRational) = oftype(x, sign(numerator(x)))


"""```
signbit(x::AbstractRational)
    === signbit(numerator(x))
```
Return the sign bit of the rational `x`.
"""
signbit(x::AbstractRational) = signbit(numerator(x))


"""```
abs(x::AbstractRatio)
    === signbit(x) ? -x : x
```
Return the absolute value of the ratio `x`.
"""
abs(x::AbstractRatio) = signbit(x) ? -x : x


"""```
abs2(x::AbstractRatio)
    === x * x
```
Return the square of the absolute value of the ratio `x`.
"""
abs2(x::AbstractRatio) = x * x


"""```
copysign(x::AbstractRatio, y)
    === signbit(y) ? -abs(x) : abs(x)
```
Return the absolute value of the ratio `x` with the sign of `y`.
"""
copysign(x::AbstractRatio, y) = signbit(y) ? -abs(x) : abs(x)


"""```
flipsign(x::AbstractRatio, y)
    === signbit(y) ? -x : x
```
Return the ratio `x` with the sign flipped according to the sign of `y`.
"""
flipsign(x::AbstractRatio, y) = signbit(y) ? -x : x


"""```
+x::AbstractRatio
```
Return the ratio `x`.
"""
+(x::AbstractRatio) = build_ratio(typeof(x), +numerator(x), denominator(x))


"""```
-x::AbstractRatio
```
Return the negative of ratio `x`.
"""
-(x::AbstractRatio) = build_ratio(typeof(x), -numerator(x), denominator(x))


"""```
-x::AbstractRational{T <: BitSigned}
```
Return the negative of rational `x` with underlying bit signed integer type.
"""
function -(x::AbstractRational{T}) where {T<:BitSigned}
    if numerator(x) == typemin(T)
        throw(OverflowError("rational numerator is typemin(T)"))
    end
    return build_ratio(typeof(x), -numerator(x), denominator(x))
end


"""```
-x::AbstractRational{T <: Unsigned}
```
Return the negative of rational `x` with underlying unsigned integer type.
"""
function -(x::AbstractRational{T}) where {T<:Unsigned}
    if numerator(x) != zero(T)
        throw(OverflowError("cannot negate unsigned number"))
    end
    return x
end


"""```
x::AbstractRational * y::AbstractRational
```
Return the product of rational `x` with rational `y`.
"""
function *(x::AbstractRational, y::AbstractRational)
    xn, yd = divgcd(numerator(x), denominator(y))
    xd, yn = divgcd(denominator(x), numerator(y))
    return build_ratio(typeof(x), checked_mul(xn, yn), checked_mul(xd, yd))
end


"""```
x::AbstractRational / y
```
Divide the rational `x` by `y`.
"""
function /(x::AbstractRational, y)
    return build_ratio(typeof(x), numerator(x) * denominator(y), denominator(x) * numerator(y))
end


"""```
x / y::AbstractRational
```
Divide `x` by the rational `y`.
"""
function /(x, y::AbstractRational)
    return build_ratio(typeof(y), numerator(x) * denominator(y), denominator(x) * numerator(y))
end


"""```
x::AbstractRational // y
```
Rationally divide the rational `x` by `y`.
"""
function //(x::AbstractRational, y)
    xn, yn = divgcd(numerator(x), y)
    return xn // checked_mul(x.den, yn)
end


"""```
x // y::AbstractRational
```
Rationally divide `x` by the rational `y`.
"""
function //(x, y::AbstractRational)
    xn, yn = divgcd(x, numerator(y))
    return checked_mul(xn, denominator(y)) // yn
end


"""```
x::AbstractRational // y::AbstractRational
```
Rationally divide the rational `x` by the rational `y`.
"""
function //(x::AbstractRational, y::AbstractRational)
    xn, yn = divgcd(numerator(x), numerator(y))
    xd, yd = divgcd(denominator(x), denominator(y))
    return checked_mul(xn, yd) // checked_mul(xd, yn)
end


"""```
x::AbstractRatio ^ n::Integer
```
Exponentiate the ratio `x` by the integer `n`.
"""
function ^(x::AbstractRatio, n::Integer)
    return n >= zero(n) ? power_by_squaring(x, n) : power_by_squaring(inv(x), -n)
end


"""```
x ^ y::AbstractRatio
```
Exponentiate `x` by the ratio `y`.
"""
^(x, y::AbstractRatio) = x^(numerator(y) / denominator(y))


"""```
x::AbstractFloat ^ y::AbstractRatio
```
Exponentiate the floating point value `x` by the ratio `y`.
"""
^(x::T, y::AbstractRatio) where {T<:AbstractFloat} = x^convert(T, y)


"""```
z::Complex ^ y::AbstractRatio
```
Exponentiate the complex number `z` by the ratio `y`.
"""
^(z::Complex{T}, y::AbstractRatio) where {T} = z^convert(typeof(one(T)^y), y)


"""```
z::Complex{<:AbstractRatio} ^ n::Bool
```
Exponentiate the complex ratio `z` by the boolean `n`.
"""
^(z::Complex{<:AbstractRatio}, n::Bool) = n ? z : one(z)


"""```
z::Complex{<:AbstractRatio} ^ n::Integer
```
Exponentiate the complex ratio `z` by the integer `n`.
"""
function ^(z::Complex{<:AbstractRatio}, n::Integer)
    return n >= zero(n) ? power_by_squaring(z, n) : power_by_squaring(inv(z), -n)
end


"""```
inv(x::AbstractRatio)
    === build_ratio(typeof(x), denominator(x), numerator(x))
```
Invert the ratio `x`.
"""
inv(x::AbstractRatio) = build_ratio(typeof(x), denominator(x), numerator(x))


"""```
fma(x::AbstractRatio, y::AbstractRatio, z::AbstractRatio)
    === (x * y) + z
```
Return the fused Mulitply-Add of the ratios `x`, `y`, and `z`.
"""
fma(x::AbstractRatio, y::AbstractRatio, z::AbstractRatio) = (x * y) + z


"""```
div(x::AbstractRational, y::Integer, r::RoundingMode)
```
Integer divide the rational `x` by the integer `y` and round accoring to rounding mode `r`.
"""
function div(x::AbstractRational, y::Integer, r::RoundingMode)
    xn, yn = divgcd(numerator(x), y)
    return div(xn, checked_mul(denominator(x), yn), r)
end


"""```
div(x::Integer, y::AbstractRational, r::RoundingMode)
```
Integer divide the integer `x` by the rational `y` and round accoring to rounding mode `r`.
"""
function div(x::Integer, y::AbstractRational, r::RoundingMode)
    xn, yn = divgcd(x, numerator(y))
    return div(checked_mul(xn, denominator(y)), yn, r)
end


"""```
div(x::AbstractRational, y::AbstractRational, r::RoundingMode)
```
Integer divide the rational `x` by the rational `y` and round accoring to rounding mode `r`.
"""
function div(x::AbstractRational, y::AbstractRational, r::RoundingMode)
    xn, yn = divgcd(numerator(x), numerator(y))
    xd, yd = divgcd(denominator(x), denominator(y))
    return div(checked_mul(xn, yd), checked_mul(xd, yn), r)
end


"""```
div(x::AbstractRatio, y)
    === div(x, y, RoundToZero)
```
Integer divide the rational `x` by `y`.
"""
div(x::AbstractRatio, y) = div(x, y, RoundToZero)


"""```
fld(x::AbstractRatio, y)
    === div(x, y, RoundDown)
```
Integer divide the rational `x` by `y` and round down.
"""
fld(x::AbstractRatio, y) = div(x, y, RoundDown)


"""```
cld(x::AbstractRatio, y)
    === div(x, y, RoundUp)
```
Integer divide the rational `x` by `y` and round up.
"""
cld(x::AbstractRatio, y) = div(x, y, RoundUp)


"""```
div(x, y::AbstractRatio)
    === div(x, y, RoundToZero)
```
Integer divide `x` by the rational `y`.
"""
div(x, y::AbstractRatio) = div(x, y, RoundToZero)


"""```
fld(x, y::AbstractRatio)
    === div(x, y, RoundDown)
```
Integer divide `x` by the rational `y` and round down.
"""
fld(x, y::AbstractRatio) = div(x, y, RoundDown)


"""```
cld(x, y::AbstractRatio)
    === div(x, y, RoundUp)
```
Integer divide `x` by the rational `y` and round up.
"""
cld(x, y::AbstractRatio) = div(x, y, RoundUp)


"""```
div(x::AbstractRatio, y::AbstractRatio)
    === div(x, y, RoundToZero)
```
Integer divide the rational `x` by the rational `y`.
"""
div(x::AbstractRatio, y::AbstractRatio) = div(x, y, RoundToZero)


"""```
fld(x::AbstractRatio, y::AbstractRatio)
    === div(x, y, RoundDown)
```
Integer divide the rational `x` by the rational `y` and round down.
"""
fld(x::AbstractRatio, y::AbstractRatio) = div(x, y, RoundDown)


"""```
cld(x::AbstractRatio, y::AbstractRatio)
    === div(x, y, RoundUp)
```
Integer divide the rational `x` by the rational `y` and round up.
"""
cld(x::AbstractRatio, y::AbstractRatio) = div(x, y, RoundUp)
