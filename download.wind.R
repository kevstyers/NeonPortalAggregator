# Plan of Attack
# Why's everything gotta be about war tho?

# Goal of Project
# Script 1: Download only the data any regular user would need for some basic 
    # Ideally verion is a function that pulls and cleans data based upon DPID input.
    # Basic version does this with one site and one dp. Scale from there.

# Script 2: Report that data by Domain 
# Script 3: Automate data pulls from Portal

# Script 1

# Load package-set

library(neonUtilities)
library(tidyverse)
library(ggplot2) # for testing :D
library(lubridate)
library(parallel)

# Grab data

# Create Data Product Lookup Table


# So we want this load by product to just grab 1 month at a time, that way 
#   when we automate this, it just grabs the last month, instead of all the months

download.wind.func <- function(site){
  
  browser()
  
  library(neonUtilities)
  library(tidyverse)
  library(ggplot2) # for testing :D
  library(lubridate)
  library(parallel)
  library(lubridate)
  
  dateTable <- readRDS(file = "X:/1_GitHub/NeonPortalAggregator/data/lookup/dateTable.RDS")
  dpLookup <- readRDS(file = "X:/1_GitHub/NeonPortalAggregator/data/lookup/dpLookup.RDS")
  
  for(i in 1:nrow(dateTable)){
    # Grab data from neon portal
    
    t <-neonUtilities::loadByProduct(dpID = dpLookup$dpID[1], 
                                     site = siteList[X],
                                     startdate = as.character(dateTable$startDays[i]), 
                                     enddate = as.character(dateTable$finalDays[i]), 
                                     check.size = FALSE, 
                                     avg = "30"
    )
    
    # Grab just the 30 min avg'ed wind data
    t1 <- t$`2DWSD_30min`
    
    # Format the columsn and save!
    t1$endDateTime <- lubridate::ymd_hms(t1$endDateTime,tz = "UTC") # some files are already posixct tbh
    t1$domainID <- base::as.factor(t1$domainID )
    t1$siteID <- base::as.factor(t1$siteID)
    t1$verticalPosition <- base::as.factor(t1$verticalPosition)
    
    # Construct File Name 
    filename <- paste0(t1$domainID[1], "_",t1$siteID[1], "_", dpLookup$dpID[1],"_",t1$startDateTime[1])
    saveDir <- "X:/1_GitHub/NeonPortalAggregator/data/DP1.00001.001/"
    # Write file
    fst::write.fst(x = t1, path = paste0(saveDir,filename, ".fst"))
  
  }
}
library(doParallel)
siteList <- readRDS(file = "X:/1_GitHub/NeonPortalAggregator/data/lookup/siteList.RDS")
system.time({
  cl <- makeCluster(detectCores())
  parLapply(cl = cl, X = (1:47), fun = download.wind.func(site = siteList))
  stopCluster(cl)
})




numCores <- parallel::detectCores()

system.time(
  results <- mclapply(X = siteList, FUN = download.wind.func, mc.cores = numCores)
)

library(parallel)
cl <- makeCluster(getOption("cl.cores", 14))


parLapply(cl, X = siteList,fun = download.wind.func())

#user  system elapsed 
#0       0      10 

stopCluster(cl)