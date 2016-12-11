#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
library(ggplot2)
diamonds$vol <- with(diamonds, x*y*z)
diam2 <- diamonds[c(-24068, -48411, -49190),]
diam3 <- diam2[diam2$vol != 0,]
set.seed(232)
samplerows <- sample(nrow(diam3), 2000)
diam3 <- diam3[samplerows, ]
mod_vol <- lm(price ~ vol, diam3)
mod_vol_color <- lm(price ~ vol * color, diam3)
p_mod_vol <- predict(mod_vol, newdata = data.frame(vol = 0:629))
p_mod_vol_color <- predict(mod_vol_color, newdata = data.frame(color = rep(unique(diam3$color), each =630), vol = 0:629))
df_mod_vol <- data.frame(vol = 0:629, f_price = p_mod_vol)
df_mod_vol_color <- data.frame(color = rep(unique(diam3$color), each =630), vol = 0:629, f_price = p_mod_vol_color)



  
df_modelpred <- reactive({
        volInput <- input$vol
        if(input$usecolor == FALSE){
                
                pred <- predict(mod_vol, newdata = data.frame(vol = volInput))
                data.frame(vol = volInput, pred = pred)
        }
        else{
                
                pred <- predict(mod_vol_color, newdata = data.frame(vol = volInput,
                                                      color = input$whichcolor))
                data.frame(vol = volInput, color = input$whichcolor, pred = pred)
        }
        
})



output$pred1 <-  renderText({
       c("Predicted diamond price: ", round(df_modelpred()$pred, 1), " USD")
        
})


output$plot1 <- renderPlot({
        if (input$usecolor == TRUE){
                ggplot() + geom_point(data = diam3, aes(color = color, x = vol, y = price), alpha = .2)+
                        geom_line(data = df_mod_vol_color, aes(color = color, x = vol, 
                                                               y = f_price), size = 1)+
                        geom_point(data = df_modelpred(), aes(color = color, x = vol, y = pred), alpha = 1, size = 8)+
                        xlab("Diamond's Volume Proxy")+ylab("Price in USD")+
                        guides(colour = guide_legend("Colour"))  
                
        } 
        else{
                ggplot() + geom_point(data = diam3, aes(x = vol, y = price), alpha = .4)+
                        geom_line(data = df_mod_vol, aes(x = vol, 
                                                         y = f_price), size = 1,  color = "red")+
                        geom_point(data = df_modelpred(), aes(x = vol, y = pred), alpha = 1, size = 8, color = "red")+
                        xlab("Diamond's Volume Proxy")+ylab("Price in USD")
        }
})

              
  })
  

