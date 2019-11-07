# src/comparison.jl
# Comparisons between Rationals and other Numeral Types

import Base: ==, <, <=


"""```
x::AbstractRatio == y::AbstractRatio
```
Check if the ratio `x` is equal to the ratio `y`.
"""
==(x::AbstractRatio, y::AbstractRatio) = ==(crossterms(x, y)...)


"""```
x::AbstractRatio == y::AbstractRational
```
Check if the ratio `x` is equal to the rational `y`.
"""
==(x::AbstractRatio, y::AbstractRational) = ==(crossterms(x, y)...)


"""```
x::AbstractRational == y::AbstractRational
```
Check if the rational `x` is equal to the rational `y`.
"""
function ==(x::AbstractRational, y::AbstractRational)
    return (denominator(x) == denominator(y)) & (numerator(x) == numerator(y))
end


"""```
x::AbstractRatio == y::Integer
```
Check if the ratio `x` is equal to the integer `y`.
"""
==(x::AbstractRatio, y::Integer) = ==(crossterms(x, y)...)


"""```
x::AbstractRational == y::Integer
```
Check if the rational `x` is equal to the integer `y`.
"""
==(x::AbstractRational, y::Integer) = isone(denominator(x)) & (numerator(x) == y)


"""```
x::AbstractRational == y::AbstractFloat
```
Check if the rational `x` is equal to the float `y`.
"""
function ==(x::AbstractRational, y::AbstractFloat)
    nx, dx = numden(x)
    if isfinite(y)
        return isone(count_ones(dx)) & (y * dx == nx)
    else
        return y == nx / dx
    end
end


"""```
x::AbstractRatio == z::Complex
```
Check if the ratio `x` is equal to the complex number `z`.
"""
==(x::AbstractRatio, z::Complex) = isreal(z) & (x == real(z))


"""```
x == y::AbstractRatio
    === (y == x)
```
Check if `x` is equal to the ratio `y`.
"""
==(x, y::AbstractRatio) = y == x


"""```
x::AbstractRatio < y::AbstractRatio
```
Check if the ratio `x` is less than the ratio `y`.
"""
function <(x::AbstractRatio, y::AbstractRatio)
    nx, dx = numden(x)
    ny, dy = numden(y)
    return dx == dy ? nx < ny : widemul(nx, dy) < widemul(ny, dx)
end


"""```
x::AbstractRatio < y
```
Check if the ratio `x` is less than `y`.
"""
<(x::AbstractRatio, y) = numerator(x) < widemul(denominator(x), y)


"""```
x < y::AbstractRatio
```
Check if `x` is less than the ratio `y`.
"""
<(x, y::AbstractRatio) = widemul(x, denominator(y)) < numerator(y)


"""```
x::AbstractRatio <= y::AbstractRatio
```
Check if the ratio `x` is less than or equal to the ratio `y`.
"""
function <=(x::AbstractRational, y::AbstractRational)
    nx, dx = numden(x)
    ny, dy = numden(y)
    return dx == dy ? nx <= ny : widemul(nx, dy) <= widemul(ny, dx)
end


"""```
x::AbstractRatio <= y
```
Check if the ratio `x` is less than or equal to `y`.
"""
<=(x::AbstractRatio, y) = numerator(x) <= widemul(denominator(x), y)


"""```
x <= y::AbstractRatio
```
Check if `x` is less than or equal to a ratio `y`.
"""
<=(x, y::AbstractRatio) = widemul(x, denominator(y)) <= numerator(y)
