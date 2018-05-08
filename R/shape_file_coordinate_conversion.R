#' Converts all files in file list to '+init=epsg:4326'
#' 
#' The function will take a list of imported shape files, and set the coordinates for mapping 
#' as seen in the Introduction to Spatial Data in R pdf by Lovelace, et. al. Function is not currently
#' in use, but may be useful in further mapping development
#' \url(https://cran.r-project.org/doc/contrib/intro-spatial-rl.pdf)
#'
#' @param file_list A character vector or name of shape files loaded into R that you want to convert.
#' @return Creates a new spatial object in the global environment with set coordinates, ending in '_coords'.
#' @export 
coordinate_conversion <- function(file_list){
  lapply(file_list, function(x){
    y <- paste(x, "coords", sep = "_")
    try(assign(y, rgdal::spTransform(get(x), CRS("+init=epsg:4326")), envir = .GlobalEnv))
  })
}