source("./SCRIPTS/Global.R")

#Granularity: MONTH

#Time series
monthts <- ts(All_years_by_months$T_Kitchen, frequency = 12, start = c(2007,01))
#Seasonal Decomposition of Time Series
strl_monthts <- monthts %>% stl(s.window = "periodic")


strl_monthts_log <- log(monthts)
autoplot(strl_monthts_log)

diff_strl_monthts_log <- diff(strl_monthts_log)
autoplot(diff_strl_monthts_log)

seas_diff_strl_monthts_log <-  diff_strl_monthts_log %>% stl(s.window = "periodic") %>% seasadj()


#Plot the ACF
ggAcf(seas_diff_strl_monthts_log)
#Plot the PACF
ggPacf(seas_diff_strl_monthts_log)

ggtsdisplay(seas_diff_strl_monthts_log)


#Split into Train and Test Set.
Activemonth_train <- window(seas_diff_strl_monthts_log, end = c(2010,01)) 
Activemonth_test <-  window(seas_diff_strl_monthts_log, start=c(2010, 02))


#Forecast




######HW

#Translate the Time series' train set to HoltWinters
activemonth_HW <- HoltWinters(Activemonth_train)
#Forecast
activemonth_HW_forecast <- forecast(activemonth_HW, h=10) #10monthts for forecast
accuracy(activemonth_HW_forecast, Activemonth_test)
#######Auto.Arima
auto_arima_month <- auto.arima(Activemonth_train)
AutoarimaPred <- forecast::forecast(auto_arima_month, h=10)

#Results
accuracy(AutoarimaPred, Activemonth_test)
#autoplot(AutoarimaPred)
