% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mapping_functions.R
\name{points_map_country}
\alias{points_map_country}
\title{Maps out all existing values of a variable in a spatialpointsdataframe, with an optionally included label}
\usage{
points_map_country(spatial_dataframe, mapping_variable, label_variable)
}
\arguments{
\item{spatial_dataframe}{The spatialpointsdataframe to be mapped}

\item{mapping_variable}{The column name to be mapped}

\item{label_variable}{The column name (typically the english name column) (OPTIONAL)}
}
\value{
Returns a tmap object, which can be viewed as a map layer
}
\description{
This function will take a spatialpointsdataframe, the variable in the spatial dataframe to be mapped, and
the variable label (optional), and create a map layer filling the points associated with the mapping variable
on a color scale. This is intented currently for only numeric data.
}
