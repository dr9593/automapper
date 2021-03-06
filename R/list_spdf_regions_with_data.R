#' Creates a vector of values (typically locations) in a spatial dataframe where data in the source dataframe existed.
#'
#' The function will look at a spatial dataframe and the source dataframe that was merged into it, and,
#' will return a vector of unique values where data in the source dataframe existed. For example,
#' if data was represented in the source dataframe at the community-level and then joined with the spatial
#' dataframe, and the region_to_subset_by column is governorate, this will return a vector of governorates where
#' data from the source dataframe exists. This is particularly useful for subsetting and facetting maps, not over an
#' entire country, but focusing only on regions where data was collected.
#'
#' @param spatial_dataframe The spatial dataframe to be subsetted
#' @param source_dataframe The dataframe that was merged into the spatial dataframe
#' @param spatial_key The column name in the spatial object's dataframe (accessed by spatial_layer@@data)
#' that was used to join the two dataframes.
#' @param dataframe_key The column name in the dataframe to be used as a key to join with the spatial data.
#' that was used as a key to join the spatial datawith the dataframe.
#' @param region_to_subset_by The column name in the spatial_dataframe you want to filter by. For example,
#' the column representing the governorate-level in a map, so you only keep governorates where communities exist where
#' data was collected.
#' @return Returns a character vectors of unique values from the region_to_subset_by column in the spatial dataframe
#' where data was collected.
#' @export
list_spdf_regions_with_data <- function(spatial_dataframe,source_dataframe,spatial_key,df_key,region_to_subset_by){
  unique(
    spatial_dataframe@data[[region_to_subset_by]][
      spatial_dataframe@data[[spatial_key]] %in% source_dataframe[[df_key]]])
}
