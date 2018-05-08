###############################################################
### Syria Mapping Example (Whole Country, Iterated by Item) ###
###############################################################

# This script will print out a map of a Syria as a background layer, and the
# and then for every column in the imported .csv file (excepting the id column used 
# to join the dataset to the spatial data), will create a map layering this column's 
# numeric data on top of the country foranalysis, then outputting the 
# resulting map to a subfolder.

# Labeling each region with data is optional, but the output is too cluttered so
# not done in this example.

# As the current HDX Syria Spatial data does shows communities, this is a good 
# example of mapping data by communities as points, instead of by polygons 
# (as would be appropriate if we were mapping subdistrict medians). 

# DEFINE NEEDED INPUTS HERE
output_folder_path <- paste("Output/Syria/Overview Maps") # Define output directory
label_variable <- "NAME_EN" # (Typically the english-language name of the spatial unit
                            # you merged the dataframe with the spatial data.)

#INPUTS ALREADY DEFINED (if ran the 01- Load Enviroment and 02 - Join Data scripts) 

#df <- imported csv dataframe containing data to be mapped
#df_key <- vartiable in csv used as key to join spaital layer with csv
#spatial_layer <- spatial layer (must have already been joined with csv data)
#spatial_key <- vartiable in spatial layer used as key to join spaital layer with csv


# Below this Line should not need to touch #
############################################

# Define output directory
dir.create(output_folder_path, recursive = TRUE)

# Set list of variables to map (all but key in original dataframe)
var_list <- names(df)[names(df) != df_key]

# Define Syria Background Map
background_map_syria_country <- function(){
  admin1 <- tm_shape(shp = syr_admin1, is.master = TRUE) + tm_borders(lwd = 2)
  admin3 <- tm_shape(shp = syr_admin3) + tm_borders(lwd = .5)
  admin4 <- tm_shape(shp = syr_pplp_adm4) + tm_dots(size = .01)
  background_map <- admin1 + admin3 + admin4
  background_map
}

#Create Syria Backgroun Map (Whole Country)
background_map <- background_map_syria_country()

#######################################
# Create Output Map, Iterate per item #
#######################################

# For every entry in var_list (referred to as 'i' below), this function will create
# a map layer visualizing the data, layer this on top of the background map, and 
# then save the output.
lapply(var_list, function(i){
  
  # fill_map_country creates a country-level map, data displayed as points.
  data_layer <- try(points_map_country(spatial_dataframe = spatial_layer,
                                       # Selects which variable to map
                                       mapping_variable = i))
  
  # Layer data_layer on top of background
  output_map <- try(background_map + data_layer)
  
  # Save Map to output file, at specified dimensions
  try(save_tmap(tm = output_map,
                # File name 
                filename = paste(output_folder_path,"/",i,"_country_overview.jpg", 
                                 sep = ""),
                # Specify dimensions of image here
                width = 1720, height = 1020, units = "px"))
})