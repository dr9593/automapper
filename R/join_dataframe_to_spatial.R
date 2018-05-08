#' Joins a dataframe to a spatial datatype based on key'
#' 
#' The function will join a dataframe to spatial data, given the column names of the keys to 
#' join by in the dataframe and spatial data. It is best practice to make sure the data in the dataframe
#' all match a value in the spatial data. If there is no match, that row will not be joined to the spatial
#' data.
#'
#' @param dataframe A dataframe to be joined.
#' @param dataframe_key The column name in the dataframe to be used as a key to join with the spatial data.
#' @param spatial_layer The spatial object to be joined.
#' @param spatial_layer_key The column name in the spatial object's dataframe (accessed by spatial_layer@@data)
#' that will be used as a key to join with the dataframe.
#' @return Returns a spatial dataframe object with all columns in the dataframe joined to the spatial databy the key.
#' @export 
join_df_to_spatial <- function(dataframe, dataframe_key, spatial_layer, spatial_layer_key){
  key_column <- dataframe[dataframe_key]
  names(key_column) <- spatial_layer_key
  dataframe <- cbind(dataframe, key_column)
  dataframe[dataframe_key] <- NULL
  df_merge <- dataframe[dataframe[[spatial_layer_key]] %in% spatial_layer[[spatial_layer_key]] == TRUE, ]
  spatial_layer@data <- dplyr::left_join(spatial_layer@data, df_merge, by = spatial_layer_key)
  spatial_layer
}