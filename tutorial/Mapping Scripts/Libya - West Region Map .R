###############################################################
### Libya Mapping Example (Subregion Iterated by Item) ###
###############################################################

# This script will print out a map of the Libya's West region as a background layer, and the
# and then for every column in the imported .csv file (excepting the id column used 
# to join the dataset to the spatial data), will create a map layering this column's 
# numeric data on top of the West for analysis, then outputting the 
# resulting map to a subfolder.

# Labeling each community with data is optional, but included in this example

# As the current HDX Libya Spatial data shows two layers of communities, this 
# is a good  example of mapping data by communities as points, instead of by polygons 
# (as would be appropriate if we were mapping subdistrict medians). 

# DEFINE NEEDED INPUTS HERE
output_folder_path <- paste("Output/Libya/Overview Maps") # Define output directory
region_level <- "ADM1_Geodi" #Column name in spatial_layer you want to focus on
region_value <- "West" #Value in column region_level in the spatial_layer you want to map
label_variable <- "community_en" # (Typically the english-language name of the spatial unit
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

# Define Background Layer
background_map_libya_subregion <-function(subregion_column_name,subregion_value){
  admin1_layer <- tm_shape(shp = Lby_Adm1_Geodivision[Lby_Adm1_Geodivision[[subregion_column_name]] == subregion_value, ], is.master = TRUE) + tm_borders(lwd = 2)
  admin2_layer <- tm_shape(shp = Lby_Adm2_Mantika[Lby_Adm2_Mantika[[subregion_column_name]] == subregion_value, ]) + tm_borders(lwd = .5)
  admin3_layer <- tm_shape(shp = Lby_Adm3_Baladiya[Lby_Adm3_Baladiya[[subregion_column_name]] == subregion_value, ]) + tm_dots(size = .02)
  admin4_layer <- tm_shape(shp = Lby_Adm4_Muhalla[Lby_Adm4_Muhalla[[subregion_column_name]] == subregion_value, ]) + tm_dots(size = .01)
  admin1_layer + admin2_layer + admin3_layer + admin4_layer
}

# Create Background Layer (Only West Region)
background_map <- background_map_libya_subregion(subregion_column_name = region_level,
                                                 subregion_value = region_value)

#######################################
# Create Output Map, Iterate per item #
#######################################

# For every entry in var_list (referred to as 'i' below), this function will create
# a map layer of the West Subregion visualizing the data, layer this on top of the 
# background map, and then save the output.
lapply(var_list, function(i){
  
  # fill_map_country creates a subregion-level map, data displayed as points.
  data_layer <- try(points_map_subregion(spatial_dataframe = spatial_layer,
                                         # Selects which variable to map
                                         mapping_variable = i,
                                         # Specifies column name in spatial_layer  where governorate is listed
                                         subregion_column_name = region_level,
                                         # Specifies governorate name that you want to map
                                         subregion_value = region_value, 
                                         # Selects variable that you want labeled on the data_layer
                                         label_variable = label_variable))
  
  # Layer data_layer on top of background
  try(output_map <- background_map + data_layer)
  
  # Save Map to output file, at specified dimensions
  save_tmap(tm = output_map, 
            #File name 
            filename = paste(output_folder_path,"/",region_value,"_",i,"_labeled.jpg", 
                             sep = ""), 
            # Specify dimensions of image here
            width = 1720, height = 1020, units = "px")
})
