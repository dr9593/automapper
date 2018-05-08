############################################
###Yemen Mapping Example (Whole Country) ###
############################################

# This will map out the entire country of Yemen as a background layer,
# and then for every column in the imported .csv file (excepting the
# id column used to join the dataset to the spatial data), will create a map
# layering this column's numeric data on top of the Yemen map for analysis,
# then outputting the resulting map to a special folder.

# Labeling each region with data is optional, as the resulting map may be too cluttered.
# In this case, simply remove the 'label_variable' parameter from the fill_map_country
# function.

# As the current HDX Yemen Spatial data does not show communities, this is a good
# example of mapping data by larger regions (in this case admin2), and displaying
# by polygons. The output could be further refined (such as changing the behavior of
# the color scale) with additional tmap package commands.

# DEFINE NEEDED INPUTS HERE
output_folder_path <- paste("Output/Yemen/Overview Maps")

#INPUTS ALREADY DEFINED (if ran the 01- Load ShapeFiles and Data and 02 - Join Data)

#df <- imported csv dataframe containing data to be mapped
#df_key <- vartiable in csv used as key to join spaital layer with csv
#spatial_layer <- spatial layer (must have already been joined with csv data)

# Below this Line should not need to touch #
############################################

# Define output directory
dir.create(output_folder_path, recursive = TRUE)

# Set list of variables to map (all but key in original dataframe)
var_list <- names(df)[names(df) != df_key]

# Define Background Map
background_map_yemen_country <-function(){
  admin1_layer <- tm_shape(shp = yem_admin1, is.master = TRUE) +tm_borders(lwd = 2)
  admin1_layer
}

# Create Background Map
background_map <- background_map_yemen_country()

#######################################
# Create Output Map, Iterate per item #
#######################################

# For every entry in var_list (referred to as 'i' below), this function will create
# a map layer visualizing the data, layer this on top of the background map, and
# then save the output.
lapply(var_list, function(i){

  # fill_map_country creates a country-level map, data displayed as polygons not points.
  data_layer <- try(fill_map_country(spatial_dataframe = spatial_layer,
                                     # Selects which variable to map
                                     mapping_variable = i))

  # Layer data_layer on top of background
  output_map <- try(background_map + data_layer)

  # Save Map to output file, at specified dimensions
  save_tmap(tm = output_map,
            #File name
            filename = paste(output_folder_path,"/",i,"_country_overview.jpg",
                             sep = ""),
            # Specify dimensions of image here
            width = 1720, height = 1020, units = "px")
})
