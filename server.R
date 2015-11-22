# server.R

#source("helpers.R")
# Loading the required libraries
library(stringr)
library(reshape2)
library(ggplot2)

# Getting and cleaning employment data from Europe
# This data can be downloaded in Eurostat website : 
# http://ec.europa.eu/eurostat/cache/metadata/fr/t2020_10_esmsip.htm
sdata <- read.table("data/t2020_10.tsv", sep="\t", header=TRUE)
# First taking out the X from the year columns
names(sdata)[2:(ncol(sdata)-1)] <- substring(names(sdata)[2:(ncol(sdata)-1)],2)
# Splitting the column sex.geo.time in two as it seems there is no time value
sdata2 <- str_split_fixed(sdata$sex.geo.time, ",", 2)
# Changing the names of the two new columns
colnames(sdata2) <- c("sexe","geo")
# Merging the 2 first columns with the year columns
sdata <- cbind(sdata2,sdata[,2:ncol(sdata)])
# Deleting the TARGET column
sdata$TARGET <- NULL
# Making the table from wide to long format for years
sdata <- melt(sdata, id.vars = c("sexe", "geo"))
colnames(sdata)[3] <- "year"
# Splitting the column value in two
sdata2 <- str_split_fixed(sdata$value, " ", 2)
colnames(sdata2) <- c("value","break_time")
# Merging the two new columns with the old dataset again
sdata <- cbind(sdata[,1:(ncol(sdata)-1)],sdata2)
# Getting rid of the "break in time series" values which is 2nd column
sdata$break_time <- NULL
# Making the value column as character and then numeric
sdata$value <- as.character(sdata$value)
sdata$value <- as.numeric(sdata$value)


shinyServer(
    function(input, output) {
        
        output$plot <- renderPlot({
            
            # The glossary for codes can be found in the following website:
            # http://ec.europa.eu/eurostat/statistics-explained/index.php/Glossary:Country_codes
            country <- switch(input$var, 
                            "Austria" = "AT",
                            "Belgium" = "BE",
                            "Bulgaria" = "BG",
                            "Croatia" = "HR",
                            "Cyprus" = "CY",
                            "Czech Republic" = "CZ",
                            "Denmark" = "DK",
                            "Estonia" = "EE",
                            "Finland" = "FI",
                            "France" = "FR",
                            "Germany" = "DE",
                            "Greece" = "EL",
                            "Hungary" = "HU",
                            "Ireland" = "IE",
                            "Italy" = "IT",
                            "Lithuania" = "LT",
                            "Luxembourg" = "LU",
                            "Latvia" = "LV",
                            "Malta" = "MT",
                            "Netherlands" = "NL",
                            "Poland" = "PL",
                            "Portugal" = "PT",
                            "Romania" = "RO",
                            "Slovakia" = "SK",
                            "Slovenia" = "SI",
                            "Spain" = "ES",
                            "Sweden" = "SE",
                            "United Kingdom" = "UK")
            
            sexec <- switch(input$radio, 
                              "Female" = "F",
                              "Male" = "M",
                              "Total" = "T")
            
            color <- switch(input$radio, 
                            "Female" = "#CC79A7",
                            "Male" = "#56B4E9",
                            "Total" = "#009E73")
            
            # Subsetting the data for the user selection
            sdata2 <- subset(sdata, geo==country & sexe==sexec, select=c(year,value))
            
            # Creating the plot
            q <- ggplot(data=sdata2, aes(year,value)) 
            q <- q + geom_bar(stat="identity", fill=color)
            q <- q + coord_cartesian(ylim = c(0,100))
            q <- q + xlab("Year*")
            q <- q + ylab("Employment rate (in %)")
            q <- q + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
            q <- q + labs(title = paste(paste("Employment rate for ", input$radio, sep = ""), 
                                        paste("population in ", input$var, sep = "")), sep = "")
            q
        })
    }
)