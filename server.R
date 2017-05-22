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


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

load('kidData.RData')
  
D<-reactive({ temp_<-temp_sub[temp_sub$ABO=='O',]
  temp_<-temp_[temp_$OPO_CTR_CODE=='08866',]
  temp_<-temp_[temp_$REGION==5,]
  temp_<-temp_[temp_$CDC_RISK_HIV_DON!="Y",]
  temp_<-temp_[temp_$KDPI<70,]
  temp_<-temp_[temp_$AGE>50,]
  temp_<-temp_[temp_$DAYS_ON_DIAL>(2*365)&!is.na(temp_$DAYS_ON_DIAL),]
  return(temp_)
})
  
output$FirstPlot<-renderPlot({
  MyData<-D()
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
