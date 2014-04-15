# Cycle Hire - Hazard rates
# 
# Author: Ulrich Atz
# Twitter: panoramadata
# Email: ulrich.atz@theodi.org

library(shiny)

# bootstrapPage lets the span for the graph be 12 instead of the default 8 with pageWithSidebar

shinyUI(bootstrapPage(

  headerPanel("Is my station free or full?"),
  
  mainPanel(

    div(class="span12",
      plotOutput("ggplot")
    ),

    div(class="span2",
      sliderInput("hazard", 
      "Tolerance",
      min = 0,
      max = 1,
      value = 0.1)
    )
  )

))
