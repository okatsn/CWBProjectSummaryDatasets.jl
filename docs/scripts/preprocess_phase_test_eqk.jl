# Instruction
# - Activate /docs
# - Make sure the current directory is CWBProjectSummaryDatasets
# - Put raw CSVs into SummaryJointStation
# - Run entire script
using DataFrames, CSV
using Chain
using Test
using CWBProjectSummaryDatasets
using OkFiles

"""
`viewcol(df, colnm) = df[!, colnm]`
"""
viewcol(df, colnm) = df[!, colnm]

function strictjoin(df1, df2; kwargs...)
    dfj = outerjoin(df1, df2; order=:left, makeunique=false, kwargs...)
    disallowmissing!(dfj) # This step make sure the `on = cols` is everywhere.
end


# SETME:
# fpath = "SummaryJointStation/PhaseTestEQK_GE_3yr_180d_500md_2023A10.csv"
fpaths = filelist(r"PhaseTestEQK.*\d{2}\.csv", "SummaryJointStation")

varicols = [:eventDist, :validRatio] # columns that are varied among dataframes grouped by :InStation for each :eventId.
colkey = :InStation # Column key for unstack

constcols = [
    # eventDist is not eventId specific
    :eventTimeStr,
    :eventSize,
    :eventLat,
    :eventLon,
    :eventId,
    :probabilityTimeStr,
    :probabilityMean,
    :prp,
    # Use `names` to list
    # names(df, Cols(r"^event", r"probability"))
] # columns that are NOT varied among dataframes grouped by :InStation for each :eventId.


# Load DataFrame
for fpath in fpaths
    df = CSV.read(fpath, DataFrame)

    # generate event ID
    transform!(df, AsTable([:eventTimeStr, :eventSize, :eventLat, :eventLon]) => ByRow(hash) => :eventId)


    # Tests
    dfgroups = groupby(df, [:eventId, :prp])
    # subdf = dfgroups[5]
    # [length(groupby(subdf, :InStation)) for subdf in dfgroups] # see which group of eventId has multiple groups of InStation

    for subdf in dfgroups
        dfs = groupby(subdf, :InStation)
        @testset "Make sure the time series is identical for all df in dfs" begin
            # For every subgroups (grouped by InStation) of each event, probability time and the values should be identical (they are event specific).
            for targetcol in [:probabilityTimeStr, :probabilityMean]
                targets = viewcol.([dfs...], targetcol)
                @test all(isequal.(Ref(targets[1]), targets))
            end
        end
    end

    # Unstack DataFrames
    myround(str::AbstractString; kwargs...) = identity(str) # This is by-far useless since InStation is not going to appear on the final DataFrame
    myround(otherwise; kwargs...) = round(otherwise; kwargs...)

    df1 = DataFrame(
        :eventTimeStr => String[],
        :eventSize => Float64[],
        :eventLat => Float64[],
        :eventLon => Float64[],
        :eventId => UInt[],
        :probabilityTimeStr => String[],
        :probabilityMean => Float64[],
        :prp => String[],
        :eventDist => String[],
        :validRatio => String[],
    )
    for subdf in dfgroups
        dfs = [(
            dfk = unstack(subdf, constcols, colkey, tag; renamecols=(x -> Symbol("$(tag)_$x")));
            select!(dfk, Not(Regex("^$tag")),
                AsTable(Regex("^$tag")) =>
                    ByRow(args -> join(myround.([args...]; digits=2), ",")) =>
                        tag)
        ) for tag in varicols]

        if length(dfs) > 1
            f(df1, df2) = strictjoin(df1, df2; on=constcols)
            dfl = reduce(f, dfs)
        end

        @test ncol(df1) == ncol(dfl)
        append!(df1, dfl)
    end

    CSV.write(pathnorepeat(fpath; suffix_fun=n -> "_compat_$n"), df1)
end


# using SmallDatasetMaker
# allfiles = filelist(r"\.csv", "SummaryJointStation")
# for fpath in allfiles
#     compress_save(CWBProjectSummaryDatasets, fpath)
# end
