#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
#
# Author Pedro A. Alonso Baigorri
#

library(shiny)
library(markdown)

shinyUI(navbarPage("Rafa Nadal Statistics & Ranking Predictor!",
           
           tabPanel("Tournament Statistics",
                    sidebarLayout(
                        
                        
                        sidebarPanel(
                        
                            p("In this tab you can analyze the relationship between the number of tournaments, grand slams, and finals reached by Rafa Nadal and his position in the ranking at the end of the year."),
                            br(),
                            
                            radioButtons("kpi", "Select the KPI to see",
                                         c("Grand Slams Won"="3", 
                                           "Grand Slams Finals (Lost)"="4",
                                           "Other Tournaments Won" = "1",
                                           "Other Finals (Lost)" = "2")
                            )
                        ),
                        mainPanel(
    
                            plotOutput("chart1")
                            
    
                        )
                    )
           ),
           
           
           tabPanel("Ranking Predictor",
                    sidebarLayout(
                        sidebarPanel(
                            
                            
                            p("In this tab you can simulate the number of tournaments and finals to reach by Rafa Nadal and run the prediction of the Ranking position at the end of the year."),
                            br(),
                            
                            sliderInput("gslamsw", "Grand Slams (Win):", min = 0, max = 4, value = 0),
                            sliderInput("otherw", "Other Tournaments (Win)", min = 0, max = 20, value = 0),
                            sliderInput("gslamsf", "Grand Slams Finals (Lost):", min = 0, max = 4, value = 0),
                            sliderInput("otherf", "Other Finals (Lost):", min = 0, max = 20, value = 0)
                            
                        ),
                    
                        mainPanel(
                            h3(textOutput("result", container = span)),
                            imageOutput("image1", height = 300)
                        )
                    )
                    
           ),
           
           tabPanel("Documentation", includeMarkdown("about.md"))
           
           
)
)
