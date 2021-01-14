library(shiny)
library(ggplot2)
source("patientnumbers.R")
shinyUI(fluidPage(h1("Heart Sounds"),
                  # Sidebar
                  sidebarLayout(
                    sidebarPanel(
                      h3("Visualization of Heart Sounds Data"),
                      selectInput("pnum",
                                  label = "Select the patient number",
                                  choices = unique(pnums), selected = pnums[1]),
                      selectInput("selecty",
                                  label = "Choose a variable to display on the y-axis",
                                  choices = list("EMAT" = 4, "S3" = 5, "S4" = 6, "SDI" = 7)),
                      dateRangeInput("dates", label= "Date Range"),
                      submitButton("Create Graph")
                    ),
                    # Show a plot
                    mainPanel(
                      plotOutput("heartplot")
                  )
)
))