using DataFrames, CSV
using Chain
using Test

df = CSV.read("SummaryJointStation/PhaseTestEQK_GE_3yr_180d_500md_2023A10.csv", DataFrame)

eachevent = groupby(df, [:eventTimeStr, :eventSize, :eventLat, :eventLon])
transform!(eachevent, groupindices => :eventId)

viewcol(df, colnm) = df[!, colnm]

subdf = groupby(df, [:eventId, :prp])[7]

combine(groupby(df, [:eventId, :prp]), nrow)
for subdf in groupby(df, [:eventId])
    dfs = groupby(subdf, :InStation)

    @testset "Make sure the time series is identical for all df in dfs" begin
        # For every subgroups (grouped by InStation) of each event, probability time and the values should be identical (they are event specific).
        for targetcol in [:probabilityTimeStr, :probabilityMean]
            targets = viewcol.([dfs...], targetcol)
            @test all(isequal.(Ref(targets[1]), targets))
        end
    end

    # dfi = dfs[1]
    for dfi in dfs

    end
end



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
