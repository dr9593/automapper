################################################################################
### Syria Mapping Example (Iterated Output, Multiple Items and Governorates with Missing) ###
################################################################################


# DEFINE NEEDED INPUTS HERE
output_folder_path <- paste("Output/Syria/Governorate Maps")
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
  admin4 <- tm_shape(shp = syr_pplp_adm4[syr_pplp_adm4[[subregion_column_name]] == subregion_value, ]) + tm_dots(size = .01)
  background_map <- admin1 + admin3 + admin4
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

  ##Create List of communities in original dataframe
  community_list <- list_spdf_regions_with_data(spatial_dataframe = spatial_layer[spatial_layer@data[[region_iterator]] == i, ],
                                                      spatial_key = spatial_key,
                                                      source_dataframe = df,
                                                      df_key = df_key,
                                                      region_to_subset_by = "NAME_EN")

  # For every entry in var_list (referred to as 'x' below), this function will create
  # a map layer visualizing the data for a particular subregion with labels, layer this on top of the background map, and
  # then save the output.
  lapply(var_list, function(x){
    ###Create Community Layer
    community_layer <- try(tm_shape(shp = spatial_layer[spatial_layer@data[[region_iterator]] == i &
                                                          spatial_layer@data[[label_variable]] %in% community_list, ]) +
                             tm_dots(col = "gray70", size = .15) +
                             tm_text(label_variable, col = "black", size = .6, bg.color="white", bg.alpha = .75, auto.placement = .5))

    #This function maps a subgregion, with data displayed as points (as they are attached to communities)
    data_layer <- try(points_map_subregion(spatial_dataframe = spatial_layer,
                                           # Selects which variable to map
                                           mapping_variable = x,
                                           # Specifies column name in spatial_layer  where governorate is listed
                                           subregion_column_name = region_iterator,
                                           # Specifies governorate name that you want to map
                                           subregion_value = i))

    # Layer data_layer on top of background
    output_map <- try(background_map + community_layer + data_layer)

    # Save Map to output file, at specified dimensions
    try(save_tmap(tm = output_map,
              #File name
              filename = paste(output_folder_path,"/",i,"/",x,"_labeled_wmissing.jpg",
                                                sep = ""),
              # Specify dimensions of image here
              width = 1720, height = 1020, units = "px"))
  })

})


