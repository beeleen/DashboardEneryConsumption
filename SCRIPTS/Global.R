pacman::p_load(rstudioapi, shiny, shinydashboard, DT, dplyr, tidyr, highcharter, shinythemes, forecast, ggplot2, plotly, TTR, RMySQL, lubridate, psych, padr, imputeTS, fpp2)

#remove scientific notation in r
options(scipen=999)

## Create a database connection 
con = dbConnect(MySQL(), user='deepAnalytics', password='Sqltask1234!', dbname='dataanalytics2018', host='data-analytics-2018.cbrosir2cswx.us-east-1.rds.amazonaws.com')

#Query 
yr_2007 <- dbGetQuery(con, "SELECT Date, Time, Sub_metering_1, Sub_metering_2, Sub_metering_3, Global_active_power, Global_reactive_power FROM yr_2007")
yr_2008 <- dbGetQuery(con, "SELECT Date, Time, Sub_metering_1, Sub_metering_2, Sub_metering_3, Global_active_power, Global_reactive_power FROM yr_2008")
yr_2009 <- dbGetQuery(con, "SELECT Date, Time, Sub_metering_1, Sub_metering_2, Sub_metering_3, Global_active_power, Global_reactive_power FROM yr_2009")
yr_2010 <- dbGetQuery(con, "SELECT Date, Time, Sub_metering_1, Sub_metering_2, Sub_metering_3, Global_active_power, Global_reactive_power FROM yr_2010")

#Combine tables into one dataframe
All_Years <- bind_rows(yr_2007, yr_2008, yr_2009, yr_2010)



#PREPROCESSING

## Combine Date and Time attribute values in a new attribute column with Paste
All_Years <-cbind(All_Years,paste(All_Years$Date,All_Years$Time), stringsAsFactors=FALSE)

## Give the new attribute in the 6th column a header name change the name
colnames(All_Years)[8] <-"DateTime"

## And move the DateTime attribute within the dataset
All_Years <- All_Years[,c(ncol(All_Years), 1:(ncol(All_Years)-1))]

## Convert DateTime from POSIXlt to POSIXct 
All_Years$DateTime <- as.POSIXct(All_Years$DateTime, "%Y/%m/%d %H:%M:%S")

## Add the time zone
attr(All_Years$DateTime, "tzone") <- "GMT+0"

#Rename Sub_meterings columns
names(All_Years)[names(All_Years) == "Sub_metering_1"] <- "Kitchen"
names(All_Years)[names(All_Years) == "Sub_metering_2"] <- "Laundry"
names(All_Years)[names(All_Years) == "Sub_metering_3"] <- "AC_Heater"


#MISSING ROWS

#Seek for missing rows and fill them with NAs  #From 2027288 to 2053263

All_Years <- All_Years %>% pad(by="DateTime", break_above = 3)


#Imputate with Interpolation
All_Years[,4:8] <- sapply(All_Years[,4:8],function(x){na_locf(x)} )



#Create new columns using Thicken 
All_Years$Year <- All_Years %>% select(DateTime) %>% thicken('year')
All_Years$Month <- All_Years %>% select(DateTime) %>% thicken('month')
All_Years$Week <- All_Years %>% select(DateTime) %>% thicken('week')
All_Years$Day <- All_Years %>% select(DateTime) %>% thicken('day')
All_Years$Hour <- All_Years %>% select(DateTime) %>% thicken('hour')

#Converting from dataframe to vector
All_Years$Year <- All_Years$Year$DateTime_year
All_Years$Month <- All_Years$Month$DateTime_month
All_Years$Week <- All_Years$Week$DateTime_week
All_Years$Day <- All_Years$Day$DateTime_day
All_Years$Hour <- All_Years$Hour$DateTime_hour

#Create new columns using Lubridate
All_Years$year <- year(All_Years$DateTime)
All_Years$month <- month(All_Years$DateTime)
All_Years$week <- week(All_Years$DateTime)
All_Years$day <- day(All_Years$DateTime)
All_Years$hour <- hour(All_Years$DateTime)

source("./SCRIPTS/ui.R")
source("./SCRIPTS/server.R")

shinyApp(ui, server)





#Prepare for shiny
