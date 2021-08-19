# Coursera_Data_Analytics in R - Week 1 - plot:2

# household_power_consumption
household_power_fileName <- "household_power_consumption.txt"

use_read_csv_sql = TRUE
saveImage = TRUE

# 2007-02-01 and 2007-02-02
print("using csv.sql")        
library(sqldf)
# get two days data , note between does not work as the Date field is a string so uning IN() 
hhpDataSql <- read.csv.sql(file=household_power_fileName,
                          sql="select * from file where Date IN('2/1/2007', '2/2/2007')",
                          sep=";",
                          colClasses=rep("character",9))
  
# summary(hhpDataSql)
  
# make a dataframe
hhpData <- data.frame(datetime = paste(as.Date(hhpDataSql$Date, "%m/%d/%Y"), hhpDataSql$Time)
                      ,Global_active_power = as.numeric(hhpDataSql$Global_active_power)
                      ,stringsAsFactors=FALSE)
hhpData <- na.omit(hhpData)

# Convert character data to datetime
hhpData$datetime <- strptime(hhpData$datetime, "%Y-%m-%d %H:%M:%S", tz = "EST5EDT")

# Plot 2
with( hhpData, 
  plot (x <- datetime, y <- Global_active_power
        ,xlab =' '
        ,ylab = 'Global Active power (kilowatts)'
        ,type = "l"))
  

if( saveImage ) {    
  # save plot to a PNG device
  dev.copy(png, file="plot2.png") ## Copy the plot to a PNG file
  dev.off() ## Close PNG device
  print("plot2.png saved")
}
