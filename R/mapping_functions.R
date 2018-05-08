#' Maps out all existing values of a variable in a spatialpolygonsdataframe, with an optionally included label
#' 
#' This function will take a spatialpolygonsdataframe, the variable in the spatial dataframe to be mapped, and
#' the variable label (optional), and create a map layer filling the polygon associated with the mapping variable
#' on a color scale. This is intented currently for only numeric data.
#'
#' @param spatial_dataframe The spatialpolygondataframe to be mapped
#' @param mapping_variable The column name to be mapped
#' @param label_variable The column name (typically the english name column) (OPTIONAL)
#' @return Returns a tmap object, which can be viewed as a map layer
#' @export 
fill_map_country <- function(spatial_dataframe,mapping_variable,label_variable){
  map <- tmap::tm_shape(shp = spatial_dataframe[is.na(spatial_dataframe[[mapping_variable]]) == FALSE, ]) +
    tmap::tm_fill(col = mapping_variable, size = .15, palette = "Reds", contrast = c(.2, .9), title = mapping_variable) +
    tmap::tm_layout(legend.outside = TRUE)
  if (!missing(label_variable)) {
    map <- map + tmap::tm_text(label_variable, col = "black", size = .6, bg.color="white", bg.alpha = .75, auto.placement = .5)
  }
  map
}

#' For a specified subsection, maps out all existing values of a variable in a spatialpolygonsdataframe, with an optionally included label
#' 
#' This function will take a spatialpolygonsdataframe, the variable in the spatial dataframe to be mapped, then the column name and value of 
#' the subregion of the spatialpolygonsdataframe to be mapped, along with the variable label (optional), and create a map layer filling the 
#' polygon associated with the mapping variable on a color scale. This is intented currently for only numeric data.
#'
#' @param spatial_dataframe The spatialpolygondataframe to be mapped
#' @param mapping_variable The column name of the data to be mapped
#' @param subregion_column_name The column name of the subregion to be mapped
#' @param subregion_value The value in the aforementioned column name that will be mapped
#' @param label_variable The column name (typically the english name column) (OPTIONAL)
#' @return Returns a tmap object, which can be viewed as a map layer
#' @export 
fill_map_subregion <- function(spatial_dataframe, mapping_variable, subregion_column_name, subregion_value, label_variable){
  map <- tmap::tm_shape(shp = spatial_dataframe[spatial_dataframe[[subregion_column_name]] == subregion_value & is.na(spatial_dataframe[[mapping_variable]]) == FALSE, ]) +
    tmap::tm_fill(col = mapping_variable, size = .15, palette = "Reds", contrast = c(.2, .9), title = mapping_variable) +
    tmap::tm_layout(title = subregion_value, legend.outside = TRUE)
  if (!missing(label_variable)) {
    map <- map + tmap::tm_text(label_variable, col = "black", size = .6, bg.color="white", bg.alpha = .75, auto.placement = .5)
  }
  map
}

#' Maps out all existing values of a variable in a spatialpointsdataframe, with an optionally included label
#' 
#' This function will take a spatialpointsdataframe, the variable in the spatial dataframe to be mapped, and
#' the variable label (optional), and create a map layer filling the points associated with the mapping variable
#' on a color scale. This is intented currently for only numeric data.
#'
#' @param spatial_dataframe The spatialpointsdataframe to be mapped
#' @param mapping_variable The column name to be mapped
#' @param label_variable The column name (typically the english name column) (OPTIONAL)
#' @return Returns a tmap object, which can be viewed as a map layer
#' @export 
points_map_country <- function(spatial_dataframe,mapping_variable,label_variable){
  map <- tmap::tm_shape(shp = spatial_dataframe[is.na(spatial_dataframe[[mapping_variable]]) == FALSE, ]) +
    tmap::tm_dots(col = mapping_variable, size = .15, palette = "Reds", contrast = c(.2, .9), title = mapping_variable) +
    tmap::tm_layout(legend.outside = TRUE)
  if (!missing(label_variable)) {
    map <- map + tmap::tm_text(label_variable, col = "black", size = .6, bg.color="white", bg.alpha = .75, auto.placement = .5)
  }
  map
}

#' For a specified subsection, maps out all existing values of a variable in a spatialpointsdataframe, with an optionally included label
#' 
#' This function will take a spatialpintsdataframe, the variable in the spatial dataframe to be mapped, then the column name and value of 
#' the subregion of the spatialpointsdataframe to be mapped, along with the variable label (optional), and create a map layer filling the 
#' points associated with the mapping variable on a color scale. This is intented currently for only numeric data.
#'
#' @param spatial_dataframe The spatialpointsdataframe to be mapped
#' @param mapping_variable The column name of the data to be mapped
#' @param subregion_column_name The column name of the subregion to be mapped
#' @param subregion_value The value in the aforementioned column name that will be mapped
#' @param label_variable The column name (typically the english name column) (OPTIONAL)
#' @return Returns a tmap object, which can be viewed as a map layer
#' @export 
points_map_subregion <- function(spatial_dataframe, mapping_variable, subregion_column_name, subregion_value, label_variable){
  map <- tmap::tm_shape(shp = spatial_dataframe[spatial_dataframe[[subregion_column_name]] == subregion_value & is.na(spatial_dataframe[[mapping_variable]]) == FALSE, ]) +
    tmap::tm_dots(col = mapping_variable, size = .15, palette = "Reds", contrast = c(.2, .9), title = mapping_variable) +
    tmap::tm_layout(title = subregion_value, legend.outside = TRUE)
  if (!missing(label_variable)) {
    map <- map + tmap::tm_text(label_variable, col = "black", size = .6, bg.color="white", bg.alpha = .75, auto.placement = .5)
  }
  map
}

