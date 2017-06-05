#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(plotly)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

load('kidData.RData')
  
D<-reactive({ 
  temp_<-temp_sub[temp_sub$ABO=='O',]
  temp_<-temp_[temp_$OPO_CTR_CODE=='08866',]
  temp_<-temp_[temp_$REGION==5,]
  temp_<-temp_[temp_$CDC_RISK_HIV_DON!="Y",]
  temp_<-temp_[temp_$KDPI<70,]
  temp_<-temp_[temp_$AGE>50,]
  temp_<-temp_[temp_$DAYS_ON_DIAL>(2*365)&!is.na(temp_$DAYS_ON_DIAL),]
  return(temp_)
})


output$FirstPlot<-renderPlot({
  if (input$calculate == 0)
    return()
  
  print(
        ggplot(MyData,aes(x=DAYS_ON_DIAL))+
            geom_density(fill='blue',colour=NA,alpha=.2)+
            #gemo_line(stat="density")+
            #facet_grid(CTR_CODE~.)+
            xlab('Time on Dialysis')+
            xlim(500,6000)+
            ylab('')+
            theme_minimal()
        )
  
})  

output$vbox <- renderValueBox({
  if (input$calculate == 0)
    return(valueBox(value='',subtitle = ''))
  
  valueBox(1.3, "Average Years Saved!", icon = icon("plus-square"))
})

output$ibox <- renderInfoBox({
  if (input$calculate == 0)
    return(infoBox(title=''))
  
  infoBox(
    "Accept Offer", "12% Chance of Failure", icon = icon("thumbs-up", lib = "glyphicon"),
    color = "green", fill = TRUE
  )
  
})


output$FirstPlotly<-renderPlotly({
  MyData<-D()
  
  p<-ggplot(MyData,aes(x=DAYS_ON_DIAL))+
      geom_density(fill='blue',colour=NA,alpha=.2)+
      #gemo_line(stat="density")+
      #facet_grid(CTR_CODE~.)+
      xlab('Time on Dialysis')+
      xlim(500,6000)+
      ylab('')+
      theme_minimal()
  
  return(ggplotly(p))
  
  
})  



})
