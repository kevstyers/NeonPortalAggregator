require(fst)
require(shiny)
require(dplyr)
require(plotly)
require(ggplot2)
require(DT)
require(tidyr)
require(data.table)
require(shinycssloaders)
require(shinydashboard)
require(viridis)
require(stringr)
require(data.table)
library(tidytable)

domainSiteList2 <- c("BART","HARV","BLAN","SCBI","SERC","OSBS","DSNY","JERC","GUAN","LAJA",
                      "UNDE","STEI","TREE","KONZ","UKFS","KONA","ORNL","MLBS","GRSM",
                      "TALL","LENO","DELA","WOOD","DCFS","NOGP","STER","CPER","RMNP","NIWO",
                      "CLBJ","OAES","YELL","MOAB","ONAQ","SRER","JORN","WREF","ABBY",
                      "SJER","SOAP","TEAK","TOOL","BARR","BONA","DEJU","HEAL","PUUM")


shinyUI(
  shinydashboard::dashboardPage(skin = "black",
    # Header
    shinydashboard::dashboardHeader(title = 'Portal Aggregator',
                                    titleWidth = 170
                                    ),
    
    # Menu bar
    shinydashboard::dashboardSidebar(
      width = 150,
      shinydashboard::sidebarMenu( id = "menu",
      shinydashboard::menuItem("Home Page", tabName = "home"),
      shinydashboard::menuItem("DP1 Plots",tabName = "DP1", icon = shiny::icon("signal", lib = "font-awesome"))
      )
    ),
    
    # Body
    shinydashboard::dashboardBody(
      shinydashboard::tabItems(
      # ----------- Swift Tab ---------
      # Note that tabsetPanel has no issues with extending the tab beyond the bottom of the page
      shinydashboard::tabItem(tabName = "home",
        shinydashboard::box(width = 12, 
            shiny::column(width = 7,
            shiny::h1("An Eddy-Covariance State of Health Dashboard (and Aquatics)"),
            shiny::h4("Users can use this application to plot data from all TIS sites to identify Eddy-Co issues, view trends, and verify calibrations/validations."),
            shiny::icon("signal", lib = "font-awesome"),
            shiny::tags$b("LC Sevices"),
            shiny::h4("Raw LC Service uptimes! This tab features an overview plot and site specific LC Service plots. You can use the LC Services tab to quickly identify sites with LC Service issues and investigate site specific LC Service outages."),
          )
        ) # End Box
      ), # End home tabName
      
      ############################################                                                              ############################################
      ############################################                                                              ############################################
      ############################################                                                              ############################################
      ############################################                       LC Services                            ############################################
      ############################################                                                              ############################################
      ############################################                                                              ############################################
      ############################################                                                              ############################################
      
      shinydashboard::tabItem(tabName = "DP1",
        shinydashboard::box(width = 12,
            shiny::column(width = 4,
                shiny::fluidRow(
                  shiny::h1("DP1 Plots"),
                ),
                shiny::uiOutput('dpidID'),
                shiny::uiOutput('UniqueStreams'),
                shiny::dateRangeInput(inputId = "dateRangeID", label = "Select Date Range for Plot",
                                      start = Sys.Date()-15, end = Sys.Date()
                                      )
                
                
            ), # End Column 7
            # shiny::column(width = 1),
            shinydashboard::tabBox(width = 12,
              shiny::tabPanel("Site Plot",width=12,
                shiny::fluidRow(width = "100%",
                  shiny::plotOutput("plot") # %>% shinycssloaders::withSpinner(color="#012D74",type="3",color.background = "white")
                ) 
              ) # End tabPanel
            ) # End tabBox
          ) # End box
        ) # end tabItem
      ) # End Tab Items 
    ) # End Dashboard Body
  ) # End of Page
) # End of UI