ui <- dashboardPage(

    #theme = shinytheme("slate"),
    dashboardHeader(title="Energy consumption", titleWidth=250),
    
    dashboardSidebar(
              
              # Sidebar panel for inputs
            
                
                sidebarMenu( 
                  menuItem("Datasets", tabName = "datasets", icon =icon("fas fa-address-book")), 
                  menuItem("Pruebas", tabName="pruebas"),
                # Input: Select the Year
                checkboxGroupInput("by_year", h3("Select the year"), c("2007" = 2007, "2008" =2008, "2009" = 2009, "2010"=2010), selected="2007"),
                
                # br() element to introduce extra vertical spacing ----
                br(),
                
                # Input: Slider for the number of observations to generate ----
                radioButtons("aggregation_function", "Aggregation Function",
                             c(
                               "Average" = "mean",
                               "Totals" = "sum")),
                
                #Input: Slider for the number of months to Forecast
                sliderInput("forecast_n_months",
                            min = 12,
                            max = 12 * 5,
                            value = 48,
                            step = 12,
                            label = "Forecast n months"
                )
                
                #cerrar sidebar
                )
                
                
                
                
                
              ),
              
              # Main panel for displaying outputs
              dashboardBody( 
              mainPanel(
                # Output: Tabset w/ plot, summary, and table ----
                tabItems(
                  tabItem( tabName = "datasets",
                tabsetPanel(type = "tabs",
                            tabPanel("Day",  
                                     highchartOutput("dayPlot")
                            ),
                            tabPanel("Week", 
                                     highchartOutput("weekPlot")
                            ),
                            tabPanel("Month",
                                     highchartOutput("monthPlot")),
                            tabPanel("Year", tableOutput("year"))
                            )),
                tabItem(tabName = "pruebas", 
                        DT::dataTableOutput("granularity") 
                        )
                
                )
              )
            
            )
            
    
    
    )
