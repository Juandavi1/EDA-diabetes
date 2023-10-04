#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

install.packages("chatgpt")
install.packages("shinycssloaders")

Sys.setenv(OPENAI_API_KEY = "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")

library(chatgpt)
library(shiny)
library(shinycssloaders)
library(tidyverse)
library(shinymaterial)


setwd(getwd())

model <- readRDS("diabetes.rds")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Verifica tu vulnerabilidad a la biabetes."),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            numericInput(inputId = "peso", label = "ingresa tu peso", value = 5, min = 5, max = 200),
            numericInput(inputId = "altura", label = "ingresa tu altura", value = 5, min = 1, max = 2),
        ),

        # Show a plot of the generated distribution
        mainPanel(
          shinycssloaders::withSpinner(
            textOutput("predict")
          ),
          plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$predict <- renderText({
      
      suggestion <- ask_chatgpt("Actúa como doctor. Genera una sugerencia para tratar a una persona con un IMC de 30. La sugerencia ,de dos parrafos y 4 renglones, debe centrarse en el objetivo principal del tratamiento: reducir el peso corporal. Se lo estás diciendo a un paciente.")
      suggestion
      gsub("\\.", ".\n", suggestion)
      
      # predict(model, newdata = data.frame(
      #   IMC = 1,
      #   Weight = 100,
      #   Height = 100
      # )
      # )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
