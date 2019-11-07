# src/comparison.jl
# Comparisons between Rationals and other Numeral Types

import Base: ==, <, <=


"""```
```
"""
==(x::AbstractRatio, y::AbstractRatio) = ==(crossterms(x, y)...)


"""```
```
"""
==(x::AbstractRatio, y::AbstractRational) = ==(crossterms(x, y)...)


"""```
```
"""
function ==(x::AbstractRational, y::AbstractRational)
    return (denominator(x) == denominator(y)) & (numerator(x) == numerator(y))
end


"""```
```
"""
==(x::AbstractRatio, y::Integer) = ==(crossterms(x, y)...)


"""```
```
"""
==(x::AbstractRational, y::Integer) = isone(denominator(x)) & (numerator(x) == y)


"""```
```
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
```
"""
==(x::AbstractRatio, z::Complex) = isreal(z) & (x == real(z))


"""```
```
"""
==(y, x::AbstractRatio) = x == y


"""```
```
"""
function <(x::AbstractRational, y::AbstractRational)
    nx, dx = numden(x)
    ny, dy = numden(y)
    return dx == dy ? nx < ny : widemul(nx, dy) < widemul(ny, dx)
end


"""```
```
"""
<(x::AbstractRational, y) = numerator(x) < widemul(denominator(x), y)


"""```
```
"""
<(x, y::AbstractRational) = widemul(x, denominator(y)) < numerator(y)


"""```
```
"""
function <=(x::AbstractRational, y::AbstractRational)
    nx, dx = numden(x)
    ny, dy = numden(y)
    return dx == dy ? nx <= ny : widemul(nx, dy) <= widemul(ny, dx)
end


"""```
```
"""
<=(x::AbstractRational, y) = numerator(x) <= widemul(denominator(x), y)


"""```
```
"""
<=(x, y::AbstractRational) = widemul(x, denominator(y)) <= numerator(y)
