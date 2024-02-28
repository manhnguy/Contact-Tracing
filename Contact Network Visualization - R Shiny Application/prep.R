# How to run the app: Run this file ->ui->server
# Load packages
require(mStats)
require(tools)
require(shiny)
require(magrittr)
require(dplyr)
require(plotly)
require(xtable)
require(epicontacts)
require(visNetwork)
require(lubridate)  # for is.POSIXct
require("shinythemes")
require(DT)
require(shinyWidgets)
require("shinydashboard")
library(igraph) #make the network
library(leaflet) #make the map
library(sp) #make sp file, use spChFIDs(), SpatialLines, function
#require(leaflet.extras2) #to make the arrows on the map, the arrows show on html only. function addArrowhead() it will show on html only. Do not load this package together with shinydashboard and shinywidgets
library(tidyverse)

# Function to prepare the network
prepare_network_new <- function(dat, case_id, infector_id){
  
  dat <- rename(dat, case_id = case_id, infector = infector_id)
  #case_id string with varname
  
  dat <- dat[ , c(which( (colnames(dat) == case_id) == TRUE) ,
                  which( (colnames(dat)!=case_id) == TRUE))]
  # ID has to be the first variable
  
  # Uses package epicontacts
  l1 <- sapply(dat$infector, length)
  contacts_rep <- rep(dat$case_id, l1)
  case_unl <- unlist(dat$infector)
  
  #### ADD LINES ABOUT THAT I SUBSET THE UNIQUE COMBINATIONS ONLY ###
  contacts <- cbind(contacts_rep, case_unl)
  contacts <- contacts[!is.na(contacts[,2]),]
  colnames(contacts) <- c("case_id", "infector")
  
  x <- make_epicontacts(linelist = dat,
                        contacts = contacts, id = "case_id", to = "case_id",
                        from = "infector",
                        directed = TRUE)
  return(x)
}


