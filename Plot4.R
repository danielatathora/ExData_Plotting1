# Coursera_Data_Analytics in R - Week 1 - plot:4

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
                      ,Global_active_power = as.numeric(hhpDataSql$Global_active_power)
                      ,Global_reactive_power = as.numeric(hhpDataSql$Global_reactive_power)
                      ,Voltage = as.numeric(hhpDataSql$Voltage)
                      ,stringsAsFactors=FALSE)
hhpData <- na.omit(hhpData)

# Convert character data to datetime
hhpData$datetime <- strptime(hhpData$datetime, "%Y-%m-%d %H:%M:%S", tz = "EST5EDT")


par(mfcol = c(2, 2)) # Create a 2 x 2 plotting matrix

# Plot 4:1  (from plot2) - Global Active power (kilowatts)
with( hhpData, 
      plot (x <- datetime, y <- Global_active_power
            ,xlab =' '
            ,ylab = 'Global Active power (kilowatts)'
            ,type = "l"))



# Plot 4:2 (from plot 3) Energy sub metering

with( hhpData, 
      plot (x <- datetime, y <- Sub_metering_1
            ,xlab = ' '
            ,ylab = 'Energy sub metering'
            ,type = "l"
            ,ylim=c(0,35)))

with(hhpData, lines(x <- datetime, y <- Sub_metering_2, col='red'))
with(hhpData, lines(x <- datetime, y <- Sub_metering_3, col='blue'))
legend("topright"
       , cex=.7
       , lty = 1
       , col = c("black","red","blue")
       , bty = "n"
       , legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


# Plot 4:3 - Voltage
with( hhpData, 
      plot (x <- datetime, y <- Voltage
            ,xlab = 'datetime'
            ,ylab = 'Voltage'
            ,type = "l"
            ,ylim=c(232,250)))


# Plot 4:4 - Global Reactive Power

with( hhpData, 
      plot (x <- datetime, y <- Global_reactive_power
            ,xlab = 'datetime'
            ,ylab = 'Global_reactive_power' 
            ,type = "l"
            ,ylim=c(0.0, 0.9)))

if( saveImage ) {    
  # save plot to a PNG device
  dev.copy(png, file="plot4.png") ## Copy the plot to a PNG file
  dev.off() ## Close PNG device
  print("plot4.png saved")
}
