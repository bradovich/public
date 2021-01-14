library(shiny)
require(RODBC)
library(ggplot2)
library(quantmod)
library(reshape)

#patientnumbers.R
chan <- odbcConnect('zlvdbsreport', uid='wradovich')
queryString <- sprintf("SELECT DISTINCT P.LastName, P.FirstName, P.PatientNum
                       FROM wcdlive.dbo.WcdPatients AS P
                       INNER JOIN Biometrics..WcdHeartSounds AS H
                       ON P.PatientNum = H.PatientNum
                       WHERE P.LastName <> 'COM4000'
                       AND P.LastName <> '34'
                       AND P.LastName <> '35'
                       AND P.LastName <> '%%DD239%%'
                       AND P.LastName <> '%%HWDEMC%%'
                       AND P.LastName <> '%%DURATION%%'
                       AND P.LastName <> '%%TS513%%'
                       AND P.LastName <> '%%SARAC584%%'
                       AND P.LastName <> '%%76TS366%%'
                       AND P.LastName <> '%%training%%'
                       AND P.LastName <>'%%TE7%%'
                       AND P.LastName <> 'EMC'
                       AND P.LastName <> 'DD239'
                       AND P.LastName <> '76DEMO'
                       AND P.LastName <> 'DURATION'
                       AND P.LastName <> 'SARAC584'
                       AND P.LastName not like '%%test%%'
                       AND P.LastName not like '%%sload%%'
                       AND P.LastName not like '%%SLAOD%%'
                       AND P.LastName not like '%%BurnIn%%'
                       AND P.LastName not like '%%Tempcycle%%'
                       AND P.LastName not like '%%TempCycle%%'
                       AND P.LastName not like '%%verbose%%'
                       AND P.LastName not like '%%76DEU%%'
                       AND P.LastName not like '%%MARV%%'
                       AND P.FirstName not like '%%1054%%'
                       AND P.FirstName not like '%%76%%'
                       AND P.FirstName <> 'SML'
                       AND P.FirstName <> '%%LIFECOR%%'
                       AND P.FirstName <> '%%ZOLL%%'
                       AND P.FirstName <> '%%JMK%%'
                       AND P.FirstName <> 'SN'
                       AND P.FirstName <> '%%SYSTEM1%%'
                       AND P.FirstName <> '%%CRTD24%%'
                       AND P.FirstName <> '%%76DEMO%%'
                       AND P.FirstName <> 'MCB'
                       AND P.FirstName <> 'AMS'
                       AND P.FirstName <> 'RAMU'
                       AND P.FirstName not like '%%STRESS%%'
                       AND P.FirstName not like '%%VALIDATION%%'
                       AND P.FirstName not like '%%BRESPON%%'
                       AND P.FirstName not like '%%64GB%%'
                       AND P.FirstName not like '%%TS33%%'
                       AND P.FirstName not like '%%TEST%%'
                       AND P.PatientNum <> '613577'
                       AND P.PatientNum <> '610954'
                       AND P.PatientNum <> '610473'
                       AND P.PatientNum <> '609532'
                       AND P.PatientNum <> '607651'
                       AND P.PatientNum <> '622209'
                       ORDER BY P.PatientNum DESC")

#bring in the table and close the channel
pnums <- sqlQuery(chan, queryString)
odbcClose(chan)

pnums <- pnums$PatientNum

#server
shinyServer(function(input, output) {
  
  output$heartplot <- renderPlot({
    inputData <- 
      chan1 <- odbcConnect('zlvdbsreport', uid='wradovich')
      queryString1 <- sprintf("SELECT PatientNum, TimeStamp, SWStatus,SWMeanQoS1,SWS3DisplayValue,SWS4DisplayValue,SysDysIndexNoEFLR
                              FROM Biometrics..WcdHeartSounds
                              WHERE PatientNum = ",input$pnum)
      
      pdata <- sqlQuery(chan1, queryString1)
      odbcClose(chan1)
      
      PatientNum <- pdata["PatientNum"]
      
      pdata$Date <- as.Date(getElement(pdata,"TimeStamp"), "%y-%m-%d")
      
      plotData <- data.frame(pdata$TimeStamp, pdata$SWMeanQoS1, pdata$Date)
      names(plotData)[1] <- paste("TimeStamp")
      names(plotData)[2] <- paste("Selected Variable")
      names(plotData)[3] <- paste("Date")
    
    plotData <- plotData[plotData$Date >= input$dates[1] & plotData$Date <= input$dates[2],]
    p <- ggplot(inputData(), aes(x=plotData$TimeStamp,y=plotData$`Selected Variable`)) + geom_point()+xlab("Time Stamp")+ylab("Selected Variable")+ggtitle("Heart Sounds Plot")
    
  print(p)
  })
})