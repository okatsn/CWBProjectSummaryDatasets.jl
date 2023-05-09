@testset "datasets.jl" begin
    using DataFrames
    df = CWBProjectSummaryDatasets.datasets()
    @test isa(df, DataFrame)
    @test isa(CWBProjectSummaryDatasets.__datasets, DataFrame)
end

@testset "Test All Datasets" begin
    using DataFrames
    for lastrow in eachrow(CWBProjectSummaryDatasets.__datasets)
        pkgnm = lastrow.PackageName
        datnm = lastrow.Dataset
        df = CWBProjectSummaryDatasets.dataset(pkgnm, datnm)
        @info "$pkgnm/$datnm goes through `PrepareTableDefault` without error."
        @test lastrow.Columns == ncol(df)
        @test lastrow.Rows == nrow(df)
    end
    @test true
end
