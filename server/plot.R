# data plotter server code

# Render list of available DPIDS
output$dpidID = shiny::renderUI({
    list.dpIDs <- base::as.data.frame(base::list.dirs(path = "X:/1_GitHub/NeonPortalAggregator/data", full.names = FALSE))
    names(list.dpIDs) <- "dpids"
    
    list.dpIDs <- list.dpIDs %>%
      dplyr::filter(stringr::str_detect(string = dpids, pattern = "DP1") == TRUE)
  
    shiny::selectInput(inputId = 'dpidID',label =  'Unique Data Streams',choices = list.dpIDs$dpids)
})


# Reactive Site Select Based Upon DPID selected by user!
reactiveInputList <- shiny::reactive({
  shiny::req(input$dpidID) # Shiny please check that this input is available before running code.
  r <- base::list.files(base::paste0("X:/1_GitHub/NeonPortalAggregator/data/",input$dpidID,"/")) 
  substr(r, start = 1, stop = 8)
})

output$UniqueStreams = shiny::renderUI({
    shiny::selectInput(inputId = 'UniqueStreams',label =  'Unique Data Streams',choices =  reactiveInputList())
})

reactiveData <- shiny::reactive({
  # t <- fst::read.fst("X:/1_GitHub/NeonPortalAggregator/data/DP1.00001.001/D01_BART_DP1.00001.001_2018-01-01_to_2020-04-30.fst")
  t <- fst::read.fst(paste0("data/",input$dpidID,"/",input$UniqueStreams,"_DP1.00001.001_2018-01-01_to_2020-04-30.fst"))

  t %>%
    dplyr::mutate(date = base::as.Date(endDateTime)) %>%
    dplyr::group_by(date, verticalPosition) %>%
    dplyr::summarise(
      windSpeedMean = base::mean(windSpeedMean, na.rm = TRUE)
  )
})



p <- shiny::reactive({
  ggplot2::ggplot(reactiveData(), aes(x = date, y = windSpeedMean, color = verticalPosition))+
    ggplot2::geom_point()
})

output$plot <- shiny::renderPlot({
  p()
})
