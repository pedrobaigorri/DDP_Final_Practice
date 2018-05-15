#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# Author Pedro A. Alonso Baigorri

library(shiny)
library(ggplot2)
require(caret)
require(C50)
require(e1071)



#reading and preparing data

file <- "data/rnadal_statistics.csv"
rnadal_data <- read.table(file, header = TRUE, sep = ";")

rnadal_data$year <- as.factor(rnadal_data$year)
rnadal_data$Ranking <- ifelse(rnadal_data$n1_eoy == 1, "Number 1", "Other position")

rnadal_data$rest_won_tournaments <- rnadal_data$total_won_tournaments - rnadal_data$won_grand_slams
rnadal_data$rest_finals <- rnadal_data$total_finals - rnadal_data$finals_grand_slams

#train model to predict the ranking
fit <- glm(as.factor(n1_eoy) ~ rest_won_tournaments + rest_finals + won_grand_slams + finals_grand_slams,
             data = rnadal_data, family=binomial(link='logit'))

# function to predict the ranking through the model
predictRanking <- function (input)
{
    
    if (input$otherw + input$otherf + input$gslamsw + input$gslamsf == 0){
        return ()    
    }
    
    
    df <- data.frame(matrix(ncol = 4, nrow = 0))
    x <- c("rest_won_tournaments", "rest_finals", "won_grand_slams", "finals_grand_slams")
    colnames(df) <- x
    

    df[1,] <- c(input$otherw, input$otherf, input$gslamsw, input$gslamsf)
    
    p <- predict(fit, newdata = df, type = "response", se.fit = TRUE)
    return (p)
    
}

# shiny server function
shinyServer(function(input, output) {

    
    # this function shows the plot about the statistics in the statistics tab
    output$chart1 <- renderPlot({
        
            if (input$kpi == "1"){
                yy <- rnadal_data$rest_won_tournaments
                yy_text <- "Rest Tournaments Won"
            }
            else if (input$kpi == "2"){
                yy <- rnadal_data$rest_finals
                yy_text <- "Rest Finals (Lost)"
            }
            else if (input$kpi == "3"){
                yy <- rnadal_data$won_grand_slams
                yy_text <- "Grand Slams won"
            }
            else{
                yy <- rnadal_data$finals_grand_slams
                yy_text <- "Final Grand Slams"
            }
        
            chart <- ggplot(data = rnadal_data, aes(x=year, y=yy, fill=Ranking)) +
            geom_bar(stat="identity") + 
            geom_text(label = yy, vjust = -0.5) +
            ggtitle("Relationships Vs Ranking and the KPI Selected on the left panel") +
            theme(legend.position="right") + 
            xlab("") +
            ylab(yy_text)

            return (chart)
    
            
    
    })

    # a testing function to show the model (not used currently)
    output$plot2 <- renderPlot({
        plot(fit)
    })
    
    # in the prediction tab this functions shows a text with the result of the prediction
    output$result <- renderText({
        
        p <- predictRanking(input)
        
        if (is.null(p)) return ("")
        
        s <- ifelse (p$fit[[1]] > 0.9, "Yes !!, I'm the number one !!", "Ups, I have to do it better !!")

            
        return (s)
        
    })
    
 
    # in the prediction tab this functions shows a picture depending on the result of the prediction   
    output$image1 <- renderImage({
        
        p <- predictRanking(input)
        
        if (is.null(p)) {
            my_image <- "images/empty.jpg"
        }
        else{
        
            my_image <- ifelse (p$fit[[1]] > 0.9, "images/img_n1.jpg", "images/img_other.jpg")    
        }
            
 
       return(list( src = my_image, contentType = "image/jpg", 
                    alt = my_image, width = "600"))
        
    }, deleteFile = FALSE)

})
