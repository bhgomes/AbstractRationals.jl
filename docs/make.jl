# docs/make.jl
# Make Documentation for {PROJECT_NAME}.jl

push!(LOAD_PATH, "../src/")

using Documenter, {PROJECT_NAME}

makedocs(
    modules   = [{PROJECT_NAME}],
    doctest   = true,
    clean     = false,
    linkcheck = false,
    format    = Documenter.HTML(prettyurls=!("local" in ARGS)),
    sitename  = "{PROJECT_NAME}.jl",
    authors   = "{FULL_NAME}",
    pages     = [
        "Home" => "index.md",
    ],
)

deploydocs(
    repo = "github.com/{USERNAME}/{PROJECT_NAME}.jl.git",
    target = "build",
    deps = nothing,
    make = nothing,
)
