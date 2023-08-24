using DataFrames, CSV

df = CSV.read("SummaryJointStation/PhaseTestEQK_GE_3yr_180d_500md_2023A10.csv", DataFrame)

eachevent = groupby(df, [:eventTimeStr, :eventSize, :eventLat, :eventLon])
transform!(eachevent, groupindices => :eventId)
