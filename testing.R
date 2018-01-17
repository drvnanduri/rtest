library(rvest)
library(XML)
library(RCurl)
library(lubridate)


base_url <- "https://coinmarketcap.com/currencies/"
urls <- paste(
  base_url,
  c(
    "bitcoin/historical-data/?start=20130428&end=20180117", 
    "ethereum/historical-data/?start=20130428&end=20180117", 
    "ripple/historical-data/?start=20130428&end=20180117", 
    "bitcoin-cash/historical-data/?start=20130428&end=20180117", 
    "litecoin/historical-data/?start=20130428&end=20180117", 
    "cardano/historical-data/?start=20130428&end=20180117", 
    "nem/historical-data/?start=20130428&end=20180117", 
    "iota/historical-data/?start=20130428&end=20180117", 
    "stellar/historical-data/?start=20130428&end=20180117", 
    "dash/historical-data/?start=20130428&end=20180117"
  ),
  sep = "" 
)

CryptoData <- lapply(urls, function(x){
  readHTMLTable(
    getURL(x))
})


class(CryptoData)
names(CryptoData) <- NULL
names(CryptoData) = c("bitcoin", "ethereum", "ripple", "bitcoin-cash", "litecoin", "cardano", "nem",
                      "iota", "stellar", "dash")


# splitting lists intod dataframes
list2env(lapply(CryptoData, as.data.frame.list), .GlobalEnv)

# Renaming all columns, even though there must be an easier way to do this stuff
names(bitcoin) <- c("Date", "Open", "High", "Low" , "Close" , "Volume", "MarketCap")
names(ethereum) <- c("Date", "Open", "High", "Low" , "Close" , "Volume", "MarketCap")
names(ripple) <- c("Date", "Open", "High", "Low" , "Close" , "Volume", "MarketCap")
names(bitcoin-cash) <- c("Date", "Open", "High", "Low" , "Close" , "Volume", "MarketCap")
names(litecoin) <- c("Date", "Open", "High", "Low" , "Close" , "Volume", "MarketCap")
names(cardano) <- c("Date", "Open", "High", "Low" , "Close" , "Volume", "MarketCap")
names(nem) <- c("Date", "Open", "High", "Low" , "Close" , "Volume", "MarketCap")
names(iota) <- c("Date", "Open", "High", "Low" , "Close" , "Volume", "MarketCap")
names(stellar) <- c("Date", "Open", "High", "Low" , "Close" , "Volume", "MarketCap")
names(dash) <- c("Date", "Open", "High", "Low" , "Close" , "Volume", "MarketCap")

###########################################################################
# onobserving we realize that the data is not sorted by date
# First let's examine Ripple data
# convert date into a format that R can understand
sapply(ripple, class)
ripple$Date = mdy(ripple$Date)
ripple = ripple %>%
  arrange(Date)

# Now use the ts package to load it into a time series model
ripple_new = ripple[,5]
#ripple_ts = ts(ripple_new, frequency = 365, start = c(2013, 8))
ripple_ts <- ts(ripple_new, start=c(2013, 8), end=c(2018, 1), frequency=365)
plot(ripple_ts)


ripple_comps = decompose(ripple_ts)
plot(ripple_comps)