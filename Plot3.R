# Coursera_Data_Analytics in R - Week 1 - plot:3

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
                      ,Sub_metering_1 = as.numeric(hhpDataSql$Sub_metering_1)
                      ,Sub_metering_2 = as.numeric(hhpDataSql$Sub_metering_2)
                      ,Sub_metering_3 = as.numeric(hhpDataSql$Sub_metering_3)
                      ,stringsAsFactors=FALSE)
hhpData <- na.omit(hhpData)

# Convert character data to datetime
hhpData$datetime <- strptime(hhpData$datetime, "%Y-%m-%d %H:%M:%S", tz = "EST5EDT")

# Plot 3
with( hhpData, 
      plot (x <- datetime, y <- Sub_metering_1
            ,xlab = ' '
            ,ylab = 'Energy sub metering'
            ,type = "l"
            ,ylim=c(0,30)))

with(hhpData,  lines(x <- datetime, y <- Sub_metering_2, col='red'))
with(hhpData, lines(x <- datetime, y <- Sub_metering_3, col='blue'))
legend("topright"
       , lty = 1
       , col = c("black","red","blue")
       , legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

if( saveImage ) {    
  # save plot to a PNG device
  dev.copy(png, file="plot3.png") ## Copy the plot to a PNG file
  dev.off() ## Close PNG device
  print("plot3.png saved")
}
