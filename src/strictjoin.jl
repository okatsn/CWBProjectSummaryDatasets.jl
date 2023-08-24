function strictjoin(df1, df2; kwargs...)
    dfj = outerjoin(df1, df2; order=:left; makeunique=false, kwargs...)
    disallowmissing!(dfj) # This step make sure the `on = cols` is everywhere.
end
