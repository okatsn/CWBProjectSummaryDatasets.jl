using DataFrames, CSV
using Chain
using Test
using CWBProjectSummaryDatasets
using OkFiles
using SmallDatasetMaker

# Unified file name to avoid too many duplicated compressed at one commit.
file_catalog = "EventMag4/Catalog.csv"
file_station = "GeoEMStation/StationInfo.csv"

# # Load the data to see if they are fine
# catalog = CSV.read(file_catalog, DataFrame)
# station_location = CSV.read(file_station, DataFrame)

for fpath in [file_catalog, file_station]
    compress_save(CWBProjectSummaryDatasets, fpath)
end
