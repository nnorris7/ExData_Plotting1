## This R script creates Plot3 as outlined in the Course Project 1 of Exploratory Data Analysis
## This script checks to see if the data file already exists in your working directory (whatever that is set to).
## If not, it downloads the data file, extracts it, and then creates the plot.

## Load the required packages
library(data.table)
library(dplyr)

## Check if data file exists, if not, download and unzip the data file
if (!file.exists("./household_power_consumption.txt")) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, destfile = "./household_power_consumption.zip", method = "curl")
    unzip("./household_power_consumption.zip")
}

## Read data into a data table
power_data <- fread("./household_power_consumption.txt")

## Convert Date column to a "date"
power_data$Date <- as.Date(power_data$Date, "%d/%m/%Y")

## Filter the large data set to just the dates we are interested in
pwr <- filter(power_data, Date == "2007-02-01" | Date == "2007-02-02")

## Clean up
rm("power_data")

## Convert data columns to numeric
pwr$Global_active_power <- as.numeric(pwr$Global_active_power)
pwr$Global_reactive_power <- as.numeric(pwr$Global_reactive_power)
pwr$Global_intensity <- as.numeric(pwr$Global_intensity)
pwr$Voltage <- as.numeric(pwr$Voltage)
pwr$Sub_metering_1 <- as.numeric(pwr$Sub_metering_1)
pwr$Sub_metering_2 <- as.numeric(pwr$Sub_metering_2)

## Create a date/time column
pwr$DateTime <- as.POSIXct(paste(pwr$Date, pwr$Time))

## Open the png device
png(file = "./plot3.png")

## Set mfcol parameter to 1 plot on the device
par(mfcol = c(1, 1))

## Create the line plots for Sub metering and the legend
plot(pwr$DateTime, pwr$Sub_metering_1, xlab = "", ylab = "Energy sub metering", type = "n")
lines(pwr$DateTime, pwr$Sub_metering_1, col = "black")
lines(pwr$DateTime, pwr$Sub_metering_2, col = "red")
lines(pwr$DateTime, pwr$Sub_metering_3, col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Close the device
dev.off()

## End of file
