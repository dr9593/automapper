###################################################
###Yemen Mapping Example (Subsetted Background) ###
###################################################

# This will map out only the admin1 levels of Yemen where there is data
# as a background layer, and then for every column in the imported .csv file
# (excepting the id column used to join the dataset to the spatial data), will
# create a map layering this column's numeric data on top of the Yemen map for
# analysis, then outputting the resulting map to a special folder.

# Labeling each region with data is optional, as the resulting map may be too cluttered.
# In this case, both versions have been produced, in option a and b below.

# As the current HDX Yemen Spatial data does not show communities, this is a good
# example of mapping data by larger regions (in this case admin2), and displaying
# by polygons. The output could be further refined (such as changing the behavior of
# the color scale) with additional tmap package commands.

# DEFINE NEEDED INPUTS HERE
output_folder_path <- paste("Output/Yemen/Overview Maps/Subset")
label_variable <- "name_en" # (Typically the english-language name of the spatial unit
                            # you merged the dataframe with the spatial data.)
region_subset <- "adm1_en" # Define region variable that you want to subset out by
                           # if it didn't contain any data(on key_spatial_layer) to facet over
background_layer_filter <- "name_en"

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

# Subset Regions with Data
region_subset_list <- list_spdf_regions_with_data(spatial_dataframe = spatial_layer,
                                               source_dataframe = df,
                                               df_key = df_key,
                                               spatial_key = spatial_key,
                                               region_to_subset_by = region_subset)
#This command creates the list of regions (in this case, adinm1) where there is data from the original
# imported csv file, which will be used to subset the background layer. They source and spatial dataframes
# and keys are used to help compare between the datasets, and the region_to_subset_by operate is used to
# finalize that list by an admin-level that was not on the source_dataframe.

# Define Background Map
background_map_yemen_subset <-function(subset_column_name,subset_value_list){
  admin1_layer <- tm_shape(shp = yem_admin1[yem_admin1[[subset_column_name]] %in% subset_value_list, ], is.master = TRUE) + tm_borders(lwd = 2)
  admin1_layer
}

# Create Background Map (Subsetted)
background_map <- background_map_yemen_subset(subset_column_name = background_layer_filter,
                                              subset_value_list = region_subset_list)

#######################################
# Create Output Map, Iterate per item #
#######################################

####################
# OPTION A: Labels #
####################

# For every entry in var_list (referred to as 'i' below), this function will create
# a map layer visualizing the data with labels, layer this on top of the background map, and
# then save the output.
lapply(var_list, function(i){

  # fill_map_country creates a country-level map, data displayed as polygons not points.
  data_layer <- try(fill_map_country(spatial_dataframe = spatial_layer,
                                     # Selects which variable to map
                                     mapping_variable = i,
                                     # Selects variable that you want labeled on the data_layer
                                     label_variable = label_variable))

  # Layer data_layer on top of background
  output_map <- try(background_map + data_layer)

  # Save Map to output file, at specified dimensions
  save_tmap(tm = output_map,
            #File name
            filename = paste(output_folder_path,"/",i,"_overview_map_subset_labeled.jpg",
                             sep = ""),
            # Specify dimensions of image here
            width = 1720, height = 1020, units = "px")
})

#######################
# OPTION B: No Labels #
#######################

# For every entry in var_list (referred to as 'i' below), this function will create
# a map layer visualizing the data with labels, layer this on top of the background map, and
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
            filename = paste(output_folder_path,"/",i,"_overview_map_subset.jpg",
                             sep = ""),
            # Specify dimensions of image here
            width = 1720, height = 1020, units = "px")
})
