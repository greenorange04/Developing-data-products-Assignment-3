#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predict diamond prices"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(

    sidebarPanel(


       sliderInput("vol",
                   "Diamond volume proxy (length times width times height)",
                   min = 50,
                   max = 629,
                   value = 100),
       checkboxInput("usecolor",
                     "Differentiate with respect to colour?",
                     value = FALSE),
       radioButtons("whichcolor", "Select colour",
                    c("D"="D", "E"="E",
                      "F"="F", "G"="G",
                      "H"="H", "I"="I",
                      "J"="J")
                    )
       
    ),
    
    
    # Show a plot of the generated distribution
    mainPanel(

        plotOutput("plot1"),
        h4(textOutput("pred1")),
        br(),
        h5("Application description:"),
        helpText("The model uses a sample (size = 2000) of the diamonds dataset
                (available from the R ggplot2 package) to estimate the price of 
                a diamond (in USD)
                based on its volume proxy measure (length times width times height)
                and (optionally) on its colour. The model itself is a simple bivariate
                linear regression with the volume proxy being the only regressor. If
                colour is taken into account, the regression is effectively 
                estimated separately for every colour. 
                The colour is defined as in the diamonds dataset description 
                (http://docs.ggplot2.org/0.9.3.1/diamonds.html):
                J is worst and D is best. See the graph and text field above
                for the result of the model prediction based
                on the input parameters as selected in the side panel"),
        helpText("To change the default volume proxy, use the horizontal slider. To take 
                colour into account, check 
                the checkbox Differentiate with respect to colour and select the 
                necessary colour using the options below. Colour selection
                has no effect on the results unless the said checkbox is checked."),
       helpText("Note that the colours of the lines in the graph have no relation to 
                the diamond colours encoded J to D."),
       helpText("Disclaimer: The model was estimated for training purposes only.
                The used algorithm is simple and is not guaranteed to generate
                reliable results.")

    )
  )
))
