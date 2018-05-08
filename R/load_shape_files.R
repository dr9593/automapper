#' Attempts to imports all .shp files in a folder
#' 
#' The package will create a vector of names of shape files found in a folder and try to loads these shape files as objects in the global enviroment.
#'
#' @param folder_path The path to the folder where all shape files are.
#' @return Character vector of names of shape files that were found in the containing folder. 
#' @export 
load_shape_files <- function(folder_path){
  file_list <- list.files(path = folder_path, pattern = "*.shp$") 
  file_list <- gsub(".shp", "", file_list) 
  lapply(file_list, function(x){
    try(assign(x, rgdal::readOGR(dsn = folder_path, layer = x), envir=.GlobalEnv))
  })
  file_list
}