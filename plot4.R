# <DATA LOADING CODE>
# only want to read the data we really need, i.e. 2007-02-01 and 2007-02-02:
data <- read.table(  "household_power_consumption.txt", 
                     header=TRUE, sep=";", nrows=3,
                     colClasses = c("character","character",
                                    rep("numeric",7))  )
format <- "%d/%m/%Y %H:%M:%S"
init <- strptime(paste(data$Date[1],data$Time[1]),
                 format=format)
# how many minutes until 01/02/2007 midnight? skip that many rows...
skip <- 1+ ( as.numeric(strptime("01/02/2007 00:00:00", format=format)) - 
                     as.numeric(init) ) / 60 # these are seconds
# also need to know how many lines to read:
nrows <- 1 + ( as.numeric(strptime("02/02/2007 23:59:00", format=format)) -
                       as.numeric(strptime("01/02/2007 00:00:00", format=format)) ) / 60

data <- read.table(  "household_power_consumption.txt", 
                     header=FALSE, sep=";", skip=skip, nrows=nrows,
                     colClasses = c("character","character",
                                    rep("numeric",7))  )
names(data) <- strsplit(readLines( "household_power_consumption.txt", n=1),
                        split=";")[[1]]
# combine "Date" and "Time" into a single POSIXlt:
t <- strptime( paste(data$Date,data$Time), format=format )
# </DATA LOADING CODE>

# plot 4: a 2x2 array of plots
png("plot4.png")
par(mfcol=c(2,2))
# 1
plot(x=t, y=data$Global_active_power, type="l",
     ylab="Global Active Power (kilowatts)", xlab="")
# 2
plot(x=t, y=data[,7], type="l", col="black",
     xlab="", ylab="Energy sub metering")
lines(x=t, y=data[,8], col="red")
lines(x=t, y=data[,9], col="blue")
legend("topright", legend=names(data)[7:9],
       col=c("black","red","blue"), lty=1, bty="n")
# 3
plot(x=t, y=data$Voltage, type="l",
     xlab="datetime", ylab="Voltage")
# 4
plot(x=t, y=data$Global_reactive_power,
     type="l", xlab="datetime",
     ylab="Global_reactive_power")
dev.off()