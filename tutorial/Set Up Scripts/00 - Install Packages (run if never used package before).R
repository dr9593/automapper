#########################################
# Prepare R Packages and Environment    #
#########################################

#This should only need to be run once, which prepares all
#packages to be downloaded to the machine.

devtools::load_all()
devtools::install()
#Downloads automapper packages
library("automapper")

installed.packages("tmap")
