source("./SCRIPTS/forecastmodels.R")
server <- shinyServer(function(input, output){

  
  
  #Day tab
  
  #Prepare the dataset
  All_years_by_days <- reactive({ 
    
    aggr <- switch(input$aggregation_function,
                   mean = mean,
                   sum = sum)
    
    All_Years %>% filter(year %in% input$by_year) %>% group_by(Day) %>%
      summarise(T_Active_energy=aggr(Global_active_power*1000/60),
                T_Reactive_energy=aggr(Global_reactive_power*1000/60),
                T_Kitchen=aggr(Kitchen),
                T_Laundry=aggr(Laundry),
                T_AC_Heater=aggr(AC_Heater))  })
  
  #Gather
  All_Years_Comb_Day <- reactive({
    daysDataPlot <-  All_years_by_days()
    daysDataPlot <-   daysDataPlot %>% gather(Sub_metering, Value, T_Active_energy:T_AC_Heater)})
  
  #Generate the Plot
  output$dayPlot <- renderHighchart({
    
    daysDataPlot <- All_Years_Comb_Day()
    highchart(type="stock") %>%  hc_add_series(data=daysDataPlot,
                                               type="line",
                                               hcaes(x=Day,
                                                     y=Value,
                                                     group=Sub_metering
                                               )) %>%
      hc_add_theme(hc_theme_darkunica()) %>% 
      hc_legend(enabled=TRUE) %>%
      hc_plotOptions(series = list(animation=FALSE))
  })
  
  
  
  
  
  
  #Week tab
  
  #Prepare the dataset
  All_years_by_weeks <- reactive({ 
    
    aggr <- switch(input$aggregation_function,
                   mean = mean,
                   sum = sum)
    
    
    All_Years %>% filter(year %in% input$by_year) %>% group_by(Week) %>%
      summarise(T_Active_energy=aggr(Global_active_power*1000/60),
                T_Reactive_energy=aggr(Global_reactive_power*1000/60),
                T_Kitchen=aggr(Kitchen),
                T_Laundry=aggr(Laundry),
                T_AC_Heater=aggr(AC_Heater))  })
  
  #Gather
  All_Years_Comb_Week <- reactive({
    weeksDataPlot <-  All_years_by_weeks()
    weeksDataPlot <-   weeksDataPlot %>% gather(Sub_metering, Value, T_Active_energy:T_AC_Heater)})
  
  #Generate the Plot
  output$weekPlot <- renderHighchart({
    
    weeksDataPlot <- All_Years_Comb_Week()
    highchart(type="stock") %>%  hc_add_series(data=weeksDataPlot,
                                               type="line",
                                               hcaes(x=Week,
                                                     y=Value,
                                                     group=Sub_metering
                                               )) %>%
      hc_add_theme(hc_theme_darkunica()) %>% 
      hc_legend(enabled=TRUE) %>%
      hc_plotOptions(series = list(animation=FALSE))
  })
  
  
  
  #Month tab
  
  #Prepare the dataset
  
  #Filter and Group By
  All_years_by_months <- reactive({ 
    
    aggr <- switch(input$aggregation_function,
                   mean = mean,
                   sum = sum)
    
    All_Years %>% filter(year %in% input$by_year) %>% group_by(Month) %>%
      summarise(T_Active_energy=aggr(Global_active_power*1000/60), 
                T_Reactive_energy=aggr(Global_reactive_power*1000/60),
                T_Kitchen=aggr(Kitchen),
                T_Laundry=aggr(Laundry), 
                T_AC_Heater=aggr(AC_Heater))  })
  
  #Gather
  All_Years_Comb_Month <- reactive({
    monthsDataPlot <-  All_years_by_months()
    monthsDataPlot <-   monthsDataPlot %>% gather(Sub_metering, Value, T_Active_energy:T_AC_Heater)})
  
  #Generate the Plot
  output$monthPlot <- renderHighchart({
    
    monthsDataPlot <- All_Years_Comb_Month()
    highchart(type="stock") %>%  hc_add_series(data=monthsDataPlot,
                                               type="line", 
                                               hcaes(x=Month,
                                                     y=Value,
                                                     group=Sub_metering
                                               )) %>% 
      hc_add_theme(hc_theme_darkunica()) %>% 
      hc_legend(enabled=TRUE) %>% 
      hc_plotOptions(series = list(animation=FALSE))
  })
  
  
  
  
  
  
  
  
  
  # Generate a summary of the data ----
  output$summary <- renderPrint({
    
  })
  
  # Generate an HTML table view of the data ----
  output$granularity <- renderDataTable({
    monthsDataPlot <-  All_years_by_months()
    monthsDataPlot
    #print("hola")
  })
  
  output$boxes <- renderText({ 
    print(as.character(input$aggregation_function))
    })
  
  output$arimaPlot <- renderPlot({
    autoplot(AutoarimaPred)
    
  })
    
})
