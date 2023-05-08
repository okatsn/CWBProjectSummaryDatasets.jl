using CWBProjectSummaryDatasets
using Documenter

DocMeta.setdocmeta!(CWBProjectSummaryDatasets, :DocTestSetup, :(using CWBProjectSummaryDatasets); recursive=true)

makedocs(;
    modules=[CWBProjectSummaryDatasets],
    authors="okatsn <okatsn@gmail.com> and contributors",
    repo="https://github.com/okatsn/CWBProjectSummaryDatasets.jl/blob/{commit}{path}#{line}",
    sitename="CWBProjectSummaryDatasets.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://okatsn.github.io/CWBProjectSummaryDatasets.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/okatsn/CWBProjectSummaryDatasets.jl",
    devbranch="master",
)
