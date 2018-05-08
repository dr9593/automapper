#########################################
# Prepare R Packages and Environment    #
#########################################

#This should only need to be run once, which prepares all
#packages to be downloaded to the machine.

#Installs packages on machine
x <- c("devtools", "tmap")
install.packages(x)

#Install automapper package
library(devtools)
install_github("dr9593/automapper")
#library("automapper") #Unsu

