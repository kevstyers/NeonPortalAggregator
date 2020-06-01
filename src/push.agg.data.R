# Build pre-agged data
site <- "HARV"
dpidID <- "DP1.00001.001"

sitesList <- fieldSites %>%
  dplyr::filter(stringr::str_detect(string = `Site Type`, pattern = "Terrestrial") == TRUE)

site <- sitesList$siteID[1]
AggData <- function(site, dpidID){
  message(paste0(site,"_",dpidID))
  
  # DEVE
  # dpidID <- "DP1.00005.001"
  # site <- "D14_JORN"
  
  t <- fst::read.fst(paste0("/home/kevin/data/",dpidID,"/",site,"_",dpidID,".fst"))

  t <- t %>% 
    dplyr::rename_at( 7, ~"mean" ) %>%
    dplyr::rename_at( 8, ~"min" ) %>%
    dplyr::rename_at( 9, ~"max" ) %>%
    dplyr::rename_at( 10, ~"variance" ) %>%
    dplyr::rename_at( 11, ~"numPts" ) %>%
    dplyr::rename_at( 12, ~"expUncert" ) %>%
    dplyr::rename_at( 13, ~"meanStdDev" ) %>%
    dplyr::rename_at( 14, ~"qfFinal" ) 

  t <- t %>%
    dplyr::mutate(date = base::as.Date(endDateTime)) %>%
    dplyr::group_by(date, verticalPosition, horizontalPosition) %>%
    dplyr::summarise(
      dailyMean = base::round(base::mean(mean, na.rm = TRUE),2),
      dailyMin  = base::round(base::min(min,  na.rm = TRUE),2),
      dailyMax  = base::round(base::max(max,  na.rm = TRUE),2),
      dailySum  = base::round(base::sum(mean,  na.rm = TRUE),2),
      dailyStdDev  = base::round(stats::sd(mean,  na.rm = TRUE),2),
      dailyRange = base::round(max(max, na.rm = TRUE)) - base::round(min(min, na.rm = TRUE)),
      dailyQF = base::round(sum(qfFinal, na.rm = TRUE))
  )
  
  message(head(t))
  
  if(dir.exists(paste0("/srv/shiny-server/NeonPortalAggregator/data/Aggregations/",dpidID,"/")) == TRUE){
    fst::write.fst(x = t, path = paste0("/srv/shiny-server/NeonPortalAggregator/data/Aggregations/",dpidID,"/",site,".fst"),compress = 0)
    message(paste0("No Directory Created for ", site, " ", dpidID))
  } else if(dir.exists(paste0("/srv/shiny-server/NeonPortalAggregator/data/Aggregations/",dpidID,"/")) == FALSE){
    dir.create(paste0("/srv/shiny-server/NeonPortalAggregator/data/Aggregations/",dpidID,"/"))
    fst::write.fst(x = t, path = paste0("/srv/shiny-server/NeonPortalAggregator/data/Aggregations/",dpidID,"/",site,".fst"),compress = 0)
    message(paste0("Directory Created for ", site, " ", dpidID))
  } else {
    message("ERROR")
  }
  
  
}

list.dpIDs <- as.data.frame(base::list.dirs(path = "/srv/shiny-server/NeonPortalAggregator/data/", full.names = FALSE))
names(list.dpIDs) <- "dpID"
list.dpIDs <- list.dpIDs %>%
  dplyr::filter(dpID != "" & dpID != "lookup" &  dpID != "DP1.00014.001"& dpID != "DP1.00022.001"
                & dpID != "DP1.00041.001" & dpID != "DP1.00094.001"& dpID != "DP1.00095.001") %>%
  dplyr::filter(stringr::str_detect(dpID, pattern = "Aggregations")==FALSE)

siteList <- data.table::as.data.table(base::readRDS(file = base::paste0("/srv/shiny-server/NeonPortalAggregator/data/lookup/siteList.RDS")))
names(siteList) <- "siteID"
 
for(i in sitesList$siteID[35:36]){
  for(j in list.dpIDs$dpID[1:1]){
    AggData(site = i, dpidID = j)  
  }
}
