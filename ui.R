#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(shinydashboard)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
    dashboardPage(
                  skin = "green",
                  
    
    header = dashboardHeader(title = "Kidney Action"), #titleWidth = 250),
    
    dashboardSidebar(#HTML('<center><img src="Asset 1_hr.png"></center>'),
        sidebarMenu(
        menuItem("Patient",icon = icon("user", lib = "glyphicon"),
                 
                 menuSubItem(sliderInput(inputId = "age", "Age:", 18, 100, 50, ticks = T, dragRange = F), icon = NULL),
                 menuSubItem(sliderInput("time_d", "Time on Dialysis:", 0, 15, 7, step = 0.5, ticks = T, dragRange = F), icon = NULL),
                 menuSubItem(selectInput(inputId = "pat_blood", "Blood Type:", choices = c("A", "A1", "A1B", "A2", "A2B", "AB", "O"), multiple = FALSE), icon = NULL),
                 #menuSubItem(sliderInput(inputId = "pra", "PRA:", 0, 100, 50, ticks = T, dragRange = F), icon = NULL),
                 menuSubItem(checkboxInput(inputId = "pat_risk", "High Risk",value = FALSE), icon = NULL),
                 #menuSubItem(checkboxInput(inputId = "high_kdpi", "KDPI > 85",value = FALSE), icon = NULL),
                 menuSubItem(selectInput(inputId = "region", "Region:", choices = c("5","4","3","2","1"), multiple = FALSE), icon = NULL)
            
                 
                 ),
        
        menuItem("Kidney",icon = icon("triangle-right", lib = "glyphicon"),
                 
                 menuSubItem(sliderInput(inputId = "kdpi", "KDPI:", 0, 100, 50, ticks = T, dragRange = F), icon = NULL),
                 #menuSubItem(selectInput(inputId = "kid_blood", "Blood Type:", choices = c("A", "A1", "A1B", "A2", "A2B", "AB", "O"), multiple = FALSE), icon = NULL),
                 menuSubItem(checkboxInput(inputId = "kid_risk", "High Risk",value = FALSE), icon = NULL)
            
        ),
        
      menuItem("Hospital",icon = icon("plus", lib = "glyphicon"),
               
               menuSubItem(sliderInput(inputId = "risk_tol", "Hospital Risk Tolerance:", 0, 100, 50, ticks = T, dragRange = F), icon = NULL)
               
               
      )),
          
        # Calculate button
        div(style = "position:absolute;center",
            actionButton(inputId = "calculate", label = icon("ok", lib = "glyphicon"))
        )
        # Use value box or info box for 'approval' or 'disapproval'
        
    ),
   
    dashboardBody(tags$head(tags$style(HTML('.info-box {min-height: 100px;} .info-box-icon {height: 100px; line-height: 100px;} .info-box-content {padding-top: 16px; padding-bottom: 0px;}'))),
                  tags$head(tags$style(HTML('.small-box {height: 100px;} .small-box-content {padding-top: 16px; padding-bottom: 0px;}'))),
      fluidRow(
        infoBoxOutput('ibox_rec'), tags$style("#ibox {width:200px;}"),
        valueBoxOutput('vbox'), tags$style("#vbox {width:250px;}")
        ),
      fluidRow(
       
        plotOutput("FirstPlot")
        )
    )
    )

))
