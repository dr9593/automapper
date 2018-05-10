################################################################################
### Syria Mapping Example (Iterated Output, Multiple Items and Governorates) ###
################################################################################

# This script will print out a map of a governorate as a background layer, and the
# and then for every column in the imported .csv file (excepting the id column used
# to join the dataset to the spatial data), will create a map layering this column's
# numeric data on top of the governorate map for  analysis, then outputting the
# resulting map to a subfolder called by the governorate's name. This will then repeat
# for every governorate where there is data.

# Labeling each region with data is optional, as the resulting map may be too cluttered.
# In this case, both versions have been produced, in option a and b below.

# As the current HDX Syria Spatial data does shows communities, this is a good
# example of mapping data by communities as points, instead of by polygons
# (as would be appropriate if we were mapping subdistrict medians).



# DEFINE NEEDED INPUTS HERE
output_folder_path <- paste("Output/Syria/Governorate Maps/Subdistrict Vizualization")
label_variable <- "NAME_EN" # (Typically the english-language name of the spatial unit
                            # you merged the dataframe with the spatial data.)
region_iterator <- "ADM1_EN" #"adm1_en" # Define region variable that you map separately by.

#INPUTS ALREADY DEFINED (if ran the 01- Load Enviroment and 02 - Join Data scripts)

#df <- imported csv dataframe containing data to be mapped
#df_key <- vartiable in csv used as key to join spaital layer with csv
#spatial_layer <- spatial layer (must have already been joined with csv data)
#spatial_key <- vartiable in spatial layer used as key to join spaital layer with csv

####SPECIAL NOTE####
# Columns in all HDX syria spatial data for governorate-level pcodes and names are
# the same EXCEPT FOR the syr_admin1 dataset. So this needs to be renamed to match
# the other column names.
syr_admin1[[region_iterator]] <- syr_admin1$NAME_EN

# Below this Line should not need to touch #
############################################
# Load 'tmap' Library if not already done.
library(tmap)

# Set list of variables to map (all but key in original dataframe)
var_list <- names(df)[names(df) != df_key]

#Select Regions to Map Separately (all govenrorates with data)
region_list <- list_spdf_regions_with_data(spatial_dataframe = spatial_layer,
                                        source_dataframe = df,
                                        spatial_key = spatial_key,
                                        df_key = df_key,
                                        region_to_subset_by = region_iterator)

# Define Background Map for Governorate
background_map_syria_subregion <- function(subregion_column_name,subregion_value){
  admin1 <- tm_shape(shp = syr_admin1[syr_admin1[[subregion_column_name]] == subregion_value, ], is.master = TRUE) + tm_borders(lwd = 2)
  admin3 <- tm_shape(shp = syr_admin3[syr_admin3[[subregion_column_name]] == subregion_value, ]) + tm_borders(lwd = .5)
  background_map <- admin1 + admin3
  background_map
}


#################################################################
# Create Output Maps Iterating by Governorate and then per item #
#################################################################

# For every entry in region_list (referred to as 'i' below), this function will
# create a subfolder for that governorate, create a background map for that
# governorate, and then start an apply function that will create and save maps
# for each item in var_list.
lapply(region_list, function(i){

  #Create Output Folder Path for Governorate
  dir.create(paste(output_folder_path,"/",i, sep = ""),
             recursive = TRUE)

  #Create Background Map for Governorate
  background_map <- background_map_syria_subregion(subregion_column_name = region_iterator,
                                                   subregion_value = i)

  ##Create List of subdistricts in original dataframe
  sbd_list <- list_spdf_regions_with_data(spatial_dataframe = spatial_layer[spatial_layer@data[[region_iterator]] == i, ],
                                                      spatial_key = spatial_key,
                                                      source_dataframe = df,
                                                      df_key = df_key,
                                                      region_to_subset_by = "NAME_EN")

  # For every entry in var_list (referred to as 'x' below), this function will create
  # a map layer visualizing the data for a particular subregion with labels, layer this on top of the background map, and
  # then save the output.
  lapply(var_list, function(x){
    ###Create Community Layer
    sbd_layer <- try(tm_shape(shp = spatial_layer[spatial_layer@data[[region_iterator]] == i &
                                                          spatial_layer@data[[label_variable]] %in% sbd_list, ]) +
                             tm_fill(col = "gray70", size = .15))

    #This function maps a subgregion, with data displayed as points (as they are attached to communities)
    data_layer <- try(fill_map_subregion(spatial_dataframe = spatial_layer,
                                           # Selects which variable to map
                                           mapping_variable = x,
                                           # Specifies column name in spatial_layer  where governorate is listed
                                           subregion_column_name = region_iterator,
                                           # Specifies governorate name that you want to map
                                           subregion_value = i))

    label_layer <- try(tm_shape(shp = spatial_layer[spatial_layer@data[[region_iterator]] == i &
                                                    spatial_layer@data[[label_variable]] %in% sbd_list, ]) +
                       tm_text(label_variable, col = "black", size = .6, bg.color="white", bg.alpha = .75, auto.placement = .5))

    # Layer data_layer on top of background
    output_map <- try(background_map + sbd_layer + data_layer + label_layer)

    # Save Map to output file, at specified dimensions
    try(save_tmap(tm = output_map,
              #File name
              filename = paste(output_folder_path,"/",i,"/",x,"_labeled_wmissing.jpg",
                                                sep = ""),
              # Specify dimensions of image here
              width = 1720, height = 1020, units = "px"))
  })

})


