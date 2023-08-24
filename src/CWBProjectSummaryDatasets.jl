module CWBProjectSummaryDatasets

using SmallDatasetMaker
# (required) See also `SmallDatasetMaker.datasets`.

function CWBProjectSummaryDatasets.dataset(package_name, dataset_name)
    SmallDatasetMaker.dataset(CWBProjectSummaryDatasets, package_name, dataset_name)
end
# (optional but recommended)
# To allow direct use of `dataset` without `SmallDatasetMaker`.

CWBProjectSummaryDatasets.datasets() = SmallDatasetMaker.datasets(CWBProjectSummaryDatasets)


using DataFrames
include("viewcol.jl")
export viewcol

include("strictjoin.jl")
export strictjoin
end
