using DataFrames, CSV
using Chain
using Test
using CWBProjectSummaryDatasets

# SETME:
df = CSV.read("SummaryJointStation/PhaseTestEQK_GE_3yr_180d_500md_2023A10.csv", DataFrame)

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

# generate event ID
eachevent = groupby(df, [:eventTimeStr, :eventSize, :eventLat, :eventLon])
transform!(eachevent, groupindices => :eventId)


# Tests
dfgroups = groupby(df, [:eventId, :prp])
subdf = dfgroups[5] # TODO: deleteme
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

for subdf in dfgroups
    dfs = [unstack(subdf, constcols, colkey, tag; renamecols=(x -> Symbol("$(tag)_$x"))) for tag in varicols]

    if length(dfs) > 1
        f(df1, df2) = strictjoin(df1, df2; on=constcols)
        reduce(f, dfs)
    end

end







combine(groupby(df, [:eventId]), nrow)




# Events in the cluster
# subdf = groupby(dfg, :eventId)[1]
for subdf in groupby(dfg, :eventId)
    groupby
end

(groupby(dfg, [:eventId, :InStation]))

@chain dfg begin
    groupby([:eventId, :InStation])
    combine([:eventId, :InStation] .=> unique; renamecols=false)
    groupby(:eventId)
    combine()
end
