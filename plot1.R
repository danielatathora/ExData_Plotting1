# Coursera_Data_Analytics in R - Week 1 - plot:1

# household_power_consumption
household_power_fileName <- "household_power_consumption.txt"

use_read_csv_sql = TRUE
saveImage = TRUE

# 2007-02-01 and 2007-02-02
if( use_read_csv_sql) {
  print("using csv.sql")        
  library(sqldf)
  # get two days data , note between does not work as the Date field is a string so uning IN() 
  hhpData <- read.csv.sql(file=household_power_fileName,
                             sql="select * from file where Date IN('2/1/2007', '2/2/2007')",
                             sep=";",
                             colClasses=rep("character",9))
  
  # summary(hhpDataSql)
} else {
  print("using read.tabe")        
  
  hhpDataAll <- read.table(file = household_power_fileName, header = TRUE, sep=';')
  # get two days data
  # hhpData <- subset(hhpDataAll, Date>="2/1/2007" & Date<="2/2/2007")
  # 23040 - not working as not Date is a string
  
  hhpData <- subset(hhpDataAll, Date=="2/1/2007" | Date=="2/2/2007" )
  # 2880 - exact string match - as only 2 days - this works
  
  rm(hhpDataAll) # we dont need to keep the full set
}

# remove rows with nulls
dim(hhpData)
hhpData <- na.omit(hhpData)
dim(hhpData)

# convert to numeric
hhpData$Global_active_power <- as.numeric(hhpData$Global_active_power)

  # histogram with added parameters
  hist(hhpData$Global_active_power,
       main="Global Active Power",
       xlab="Global Active Power (kilowatts)",
       xlim=c(0,6),
       ylim=c(0,1380),
       col='red'
  )

if( saveImage ) {    
  # save plot to a PNG device
  dev.copy(png, file="plot1.png") ## Copy the plot to a PNG file
  dev.off() ## Close PNG device
  print("plot1.png saved")
}
  