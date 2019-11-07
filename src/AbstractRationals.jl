# src/AbstractRationals.jl
# Abstractions for Rational Numbers

__precompile__(true)

"""```
module AbstractRationals
```
Abstractions for Rational Numbers
See https://github.com/bhgomes/AbstractRationals.jl for more details.
"""
module AbstractRationals

include("core.jl")
include("conversion.jl")
include("rounding.jl")
include("arithmetic.jl")
include("comparison.jl")

end  # module AbstractRationals
