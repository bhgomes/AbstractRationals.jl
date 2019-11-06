# docs/make.jl
# Make Documentation for AbstractRationals.jl

push!(LOAD_PATH, "../src/")

using Documenter, AbstractRationals

makedocs(
    modules   = [AbstractRationals],
    doctest   = true,
    clean     = false,
    linkcheck = false,
    format    = Documenter.HTML(prettyurls=!("local" in ARGS)),
    sitename  = "AbstractRationals.jl",
    authors   = "Brandon H Gomes",
    pages     = [
        "Home" => "index.md",
    ],
)

deploydocs(
    repo = "github.com/bhgomes/AbstractRationals.jl.git",
    target = "build",
    deps = nothing,
    make = nothing,
)
