# src/conversion.jl
# Convert Rationals into other Numeral Types

import Base: Bool, float, promote_rule


"""
"""
function Bool(x::AbstractRational)
    return iszero(x) ? false : isone(x) ? true : throw(InexactError(:Bool, Bool, x))
end


"""
"""
float(::Type{AbstractRational{T}}) where {T} = float(T)


"""
"""
function promote_rule(
    ::Type{<:AbstractRational{T}},
    ::Type{S}
) where {T,S<:AbstractFloat}
    return promote_type(T,S)
end
