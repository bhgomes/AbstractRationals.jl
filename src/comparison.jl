# src/comparison.jl
# Comparisons between Rationals and other Numeral Types

import Base: ==, <, <=


"""
"""
==(x::AbstractRational, y::AbstractRational) = (denominator(x) == denominator(y)) & (numerator(x) == numerator(y))


"""
"""
function <(x::AbstractRational, y::AbstractRational)
    return denominator(x) == denominator(y) ? numerator(x) < numerator(y) : widemul(numerator(x),denominator(y)) < widemul(denominator(x),numerator(y))
end


function <=(x::AbstractRational, y::AbstractRational)
    return denominator(x) == denominator(y) ? numerator(x) <= numerator(y) : widemul(numerator(x),denominator(y)) <= widemul(denominator(x),numerator(y))
end


"""
"""
==(x::AbstractRational, y::Integer) = isone(denominator(x)) & (numerator(x) == y)


"""
"""
<(x::AbstractRational, y::Integer) = numerator(x) < widemul(denominator(x), y)


"""
"""
<(x::Integer , y::AbstractRational) = widemul(x, denominator(y)) < numerator(y)


"""
"""
<=(x::AbstractRational, y::Integer) = numerator(x) <= widemul(denominator(x), y)


"""
"""
<=(x::Integer , y::AbstractRational) = widemul(x, denominator(y)) <= numerator(y)


"""
"""
function ==(q::AbstractRational, x::AbstractFloat)
    if isfinite(x)
        return isone(count_ones(q.den)) & (x*q.den == q.num)
    else
        return x == q.num/q.den
    end
end


"""
"""
==(x::AbstractRational, z::Complex) = isreal(z) & (x == real(z))


"""
"""
==(y, x::AbstractRational) = x == y
