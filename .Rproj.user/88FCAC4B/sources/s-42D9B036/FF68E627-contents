# data plotter server code

# Render list of available DPIDS
output$dpidID = shiny::renderUI({
    list.dpIDs <- base::as.data.frame(base::list.dirs(path = "data", full.names = FALSE))
    names(list.dpIDs) <- "dpids"
    
    list.dpIDs <- list.dpIDs %>%
      dplyr::filter(stringr::str_detect(string = dpids, pattern = "DP1") == TRUE)
  
    shiny::selectInput(inputId = 'dpidID',label =  'Unique Data Streams',choices = list.dpIDs$dpids)
})


# Reactive Site Select Based Upon DPID selected by user!
reactiveInputList <- shiny::reactive({
  shiny::req(input$dpidID) # Shiny please check that this input is available before running code.
  r <- base::list.files(base::paste0("data/",input$dpidID,"/")) 
  substr(r, start = 1, stop = 8)
})

output$UniqueStreams = shiny::renderUI({
    shiny::selectInput(inputId = 'UniqueStreams',label =  'Unique Data Streams',choices =  reactiveInputList())
})

reactiveData <- shiny::reactive({
  req(input$dpidID)
  req(input$UniqueStreams)
  # t1 <- fst::read.fst("X:/1_GitHub/NeonPortalAggregator/data/DP1.00001.001/D01_BART_DP1.00001.001.fst")
  # t2 <- fst::read.fst("X:/1_GitHub/NeonPortalAggregator/data/DP1.00004.001/D01_BART_DP1.00004.001.fst")
  # t3 <- fst::read.fst("X:/1_GitHub/NeonPortalAggregator/data/DP1.00001.001/D01_BART_DP1.00001.001.fst")
  # t4 <- fst::read.fst("X:/1_GitHub/NeonPortalAggregator/data/DP1.00001.001/D01_BART_DP1.00001.001.fst")
  
  t <- fst::read.fst(paste0("data/",input$dpidID,"/",input$UniqueStreams,"_",input$dpidID,".fst"))
  
  t <- t %>% 
    dplyr::rename_at( 7, ~"mean" ) %>%
    dplyr::rename_at( 8, ~"min" ) %>%
    dplyr::rename_at( 9, ~"max" ) %>%
    dplyr::rename_at( 10, ~"variance" ) %>%
    dplyr::rename_at( 11, ~"numPts" ) %>%
    dplyr::rename_at( 12, ~"expUncert" ) %>%
    dplyr::rename_at( 13, ~"meanStdDev" ) %>%
    dplyr::rename_at( 14, ~"qfFinal" ) 


  t %>%
    dplyr::mutate(date = base::as.Date(endDateTime)) %>%
    dplyr::group_by(date, verticalPosition) %>%
    dplyr::summarise(
      dailyMean = base::mean(mean, na.rm = TRUE),
      dailyMin = base::mean(min, na.rm = TRUE),
      dailyMax = base::mean(max, na.rm = TRUE),
  )
})



p <- shiny::reactive({
  req(input$stat)
  req(input$dpidID)
  req(input$UniqueStreams)
  if(input$stat == "dailyMean"){
  ggplot2::ggplot(reactiveData(), aes(x = date, y = dailyMean, color = verticalPosition))+
    ggplot2::geom_point()
  } else if(input$stat == "dailyMin"){
  ggplot2::ggplot(reactiveData(), aes(x = date, y = dailyMin, color = verticalPosition))+
    ggplot2::geom_point()
  } else if(input$stat == "dailyMax"){
  ggplot2::ggplot(reactiveData(), aes(x = date, y = dailyMax, color = verticalPosition))+
    ggplot2::geom_point()
  }
})

output$plot <- shiny::renderPlot({
  p()
})
