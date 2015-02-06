## First set the workgin directory to the diretcory above where you want to 
## download the data file to
get.pwr.data <- function(wd="./", download=TRUE) {
    setwd(wd)
    if(download) {
        ## download & unzip the file
        fileUrl <-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl, destfile="./data/household_power_consumption.zip", method ="curl")
        ## unzip the file
        unzip("./data/household_power_consumption.zip", exdir="./data/")
    }
    ## read the table
    pwr.cnsm.data <- read.table("./data/household_power_consumption.txt", 
                                header= TRUE, sep=";", na.strings = "?")
    
    ## Create a date_time field
    pwr.cnsm.data$Date_Time <- do.call(paste, pwr.cnsm.data[, c("Date", "Time")])
    pwr.cnsm.data$Date_Time <- strptime(pwr.cnsm.data$Date_Time, "%d/%m/%Y %H:%M:%S")
    
    ## get only data for 2007-02-01 and 2007-02-02
    pwr.cnsm.data <- subset(pwr.cnsm.data, pwr.cnsm.data$Date_Time 
                            > as.POSIXct("2007-01-31 23:59:59")
                            & pwr.cnsm.data$Date_Time 
                            < as.POSIXct("2007-02-03 00:00:00"))
    pwr.cnsm.data$Date <- as.Date(pwr.cnsm.data$Date, "%d/%m/%Y")
    pwr.cnsm.data
}

## Put the data in a data frame. change last argument to FALSE if file already
## downloaded to wd/data/
pwr.data <- get.pwr.data("/home/honto/Coursera/Exploratory_Data_Analysis/Asn1"
                         , TRUE)

#plot
with(pwr.data, plot(Date_Time, Sub_metering_1, xlab=""
                    , ylab="Energy sub metering", type="l"))
with(pwr.data, lines(Date_Time, Sub_metering_2, type="l", col="red"))
with(pwr.data, lines(Date_Time, Sub_metering_3, type="l", col="blue"))

# copy to png
dev.copy(png, file="./plots/plot3.png")
dev.off()
