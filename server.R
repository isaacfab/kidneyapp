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
  temp_<-temp_sub[temp_sub$ABO==input$pat_blood,]
  #temp_<-temp_[temp_$OPO_CTR_CODE=='08866',]
  temp_<-temp_[temp_$REGION==input$region,]
  x<-input$pat_risk
  if(x==FALSE){y<-"N"}
  if(x==TRUE){y<-"Y"}
  temp_<-temp_[temp_$CDC_RISK_HIV_DON!=y,]
  temp_<-temp_[temp_$KDPI<input$kdpi,]
  temp_<-temp_[temp_$AGE>input$age,]
  z<-(input$time_d)*365
  temp_<-temp_[temp_$DAYS_ON_DIAL>z&!is.na(temp_$DAYS_ON_DIAL),]
  return(temp_)
})

z<-reactive({
  k_len<-18.005*input$kdpi^(-0.218)
  nk_len<-18.005*(mean(D()$KDPI))^(-0.218)
  #extra years of kidney by waiting
  x<-nk_len-k_len
  #time on dialysis if wait
  y<-(mean(D()$DAYS_ON_DIAL)/365)-input$time_d
  z<-y-x
  
  return(z)
})

output$FirstPlot<-renderPlot({
  if (input$calculate == 0)
    return()
  
  print(
        ggplot(D(),aes(x=DAYS_ON_DIAL))+
            geom_density(fill='blue',colour=NA,alpha=.2)+
            #gemo_line(stat="density")+
            #facet_grid(CTR_CODE~.)+
            xlab('Expected Time on Dialysis (Days)')+
            xlim(500,6000)+
            ylab('Density')+
            ggtitle('Distribution of Time on Dialysis if Reject')+
            theme_minimal()
        )
  
})  

output$vbox <- renderValueBox({

  if (input$calculate == 0)
    return(valueBox(value='0',subtitle = 'Average Years Saved',color = "green"))
  
  valueBox(round(z(),1), "Average Years Saved!", icon = icon("plus-square")) #color = "purple"
})

# Info box to display depending on offer
x = 51 # x is variable for chance of success, >50 is success and <50 is reject, change with if statment

output$ibox_rec <- renderInfoBox({
    if (input$calculate == 0) 
      return(infoBox(title='Enter Info on Left Menu!', color = "green"))
    if(z()>0){
      return(infoBox(
      "Accept Offer", icon = icon("thumbs-up", lib = "glyphicon"),color = "green", fill = TRUE, width = 90)
      )
    }
    if(z()<=0){
      return(
        infoBox(
          "Reject Offer", icon = icon("thumbs-down", lib = "glyphicon"),
          color = "red", fill = TRUE, width = 90)
      )
    }
    
  })






})
