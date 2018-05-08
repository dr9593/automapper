############################
# Load Data For Mapping    #
############################

# Loads automapper and associated packages
library("automapper")
library(tmap)

# Shapefiles & Test Data
# Note: File paths may need to be updated depending on where data is stored.
syria_shapefiles <- "data/spatial/Syria/Administrative Boundaries, Populated Places/syr_admin_shp_utf8_180131"
syria_test_data <- "data/prices/Syria/smeb_towns_not_besieged.csv"

yemen_shapefiles <- "data/spatial/Yemen"
yemen_test_data <- "data/prices/Yemen/march_names.csv"

libya_shapefiles <- "data/spatial/Libya"
libya_test_data <- "data/prices/Libya/prices.csv"

# Load Shapefiles
load_shape_files(folder_path = libya_shapefiles)

#Load Data
df <- read.csv(libya_test_data, sep = ",",
               fileEncoding = "UTF-8",
               stringsAsFactors = FALSE)

