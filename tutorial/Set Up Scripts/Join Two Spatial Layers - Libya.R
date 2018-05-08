###############################
# Merging Spatial Data Frames #
###############################

# Both admin3 and admin4 levels in Libya refer to communities and
# are represented as points in spatial data, and current test data
# only refers to communities. So we will need to first merge
# admin3 and admin4 spatial dataframes into single spatial dataframe
# before joining with test data.

layer_a <- Lby_Adm3_Baladiya #Select First Spatial Layer to join
ida_en <- "ADM3_Balad" #Select Community ID in English
ida_ar <- "ADM3_Bal_1" #Select Community ID in Arabic
ida_code <- "ADM3_Bal_2" #Select Community ID PCODE

layer_b <- Lby_Adm4_Muhalla #Select Second Spatial Layers to join
idb_en <- "ADM4_Muhal" #Select Community ID in English
idb_ar <- "ADM4_Muh_1" #Select Community ID in Arabic
idb_code <- "ADM4_Muh_2" #Select Community ID PCODE

#Generate Vectors of variables to rename
layer_a_communityids <- c(ida_en, ida_ar, ida_code)
layer_b_communityids <- c(idb_en, idb_ar, idb_code)

#CreateVector in same order and length of desired renamed columns
output_communityids <- c("community_en", "community_ar", "community_id")

#Create List of spatial layers to loop over
input_layer_list <- list(layer_a, layer_b)

#Create List vectors that will be copied and renamed
input_id_list <- list(layer_a_communityids,layer_b_communityids)

#Define function to  copy and Rename Columns in Spatial DataFrame
rename_columns_spatialdataframe <- function(spatialdataframe, new_column_names, old_column_names){
  count <- 1
  for (variable in old_column_names) {
    spatialdataframe@data[[output_communityids[count]]] <- spatialdataframe@data[[variable]]
    count <- count + 1
  }

  #Return spatial data frame
  spatialdataframe
}

#Loops over each layer in list
list_count <- 1
for (layer in input_layer_list){
  layer <- rename_columns_spatialdataframe(spatialdataframe = layer,
                                           new_column_names = output_communityids,
                                           old_column_names = input_id_list[[list_count]])
  input_layer_list[[list_count]] <- layer
  list_count <- list_count + 1
}

#Bind into one large spatialpointsdataframe
spatial_layer <- raster::bind(input_layer_list[[1]], input_layer_list[[2]])

