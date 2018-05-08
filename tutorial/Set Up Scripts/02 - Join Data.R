###############################
# Join data to spatial data   #
###############################

# NOTE: Please Run 'Join Two Spatial Layers - Libya.R' prior to this script if
# loading libya data.

#Yemen
df_key <- "district" #Key variable in dataframe to merge to geospatial data
spatial_key <- "name_en" ##Key variable in geospatial data to merge with dataframe
spatial_layer <- yem_admin2  #Define geospatial data

# Syria
df_key <- "q_town"
spatial_key <- "PCODE"
spatial_layer <- syr_pplp_adm4

# Libya
df_key <- "community"
spatial_key <- "community_en"

## Join data to Shape File Layer
spatial_layer <- join_df_to_spatial(dataframe = df,
                                    dataframe_key = df_key,
                                    spatial_layer = spatial_layer,
                                    spatial_layer_key = spatial_key)
