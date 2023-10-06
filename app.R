#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# don't worry about it! It has a 1USD limit.
Sys.setenv(OPENAI_API_KEY = "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")

library(chatgpt)
library(shiny)
library(shinycssloaders)
library(tidyverse)


setwd(getwd())

model <- readRDS("diabetes.rds")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Ingresa los datos solicitados."),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            numericInput(inputId = "IMC", label = "ingresa tu indice de masa corporal", value = 30, min = 5, max = 200),
            numericInput(inputId = "Glucose", label = "ingresa tu ultima toma de glucosa", value = 100, min = 1, max = 2),
            numericInput(inputId = "AvBloodPressure", label = "ingresa tu ultima toma de persión sanguinea ", value = 100, min = 1, max = 2),
            numericInput(inputId = "SpO2", label = "ingresa tu ultima toma de oximetria", value = 100, min = 1, max = 2),
            numericInput(inputId = "HeartRate", label = "ingresa tu ultima toma de frecuencia cardiaca", value = 100, min = 1, max = 2),
            actionButton("do", "Verificar!")
        ),

        # Show a plot of the generated distribution
        mainPanel(
          h1("Predicción paciente vulnerable a diabetes."),
          shinycssloaders::withSpinner(
             textOutput("predict")
          )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    gpt <- eventReactive(input$do, {
      prompt <- "Actúa como doctor. Genera algunas sugerencias para evitar la diabetes. La sugerencia debe ser corta y centrarse en el objetivo principal del tratamiento: reducir el riesgo a diabetes. Se lo estás diciendo a un paciente."
      ask_chatgpt(prompt)
    })

    output$predict <- renderText({

      cluster <- predict(model, newdata = data.frame(
         IMC = input$IMC,
         Glucose = input$Glucose,
         AvBloodPressure = input$AvBloodPressure,
         SpO2 = input$AvBloodPressure,
         HeartRate = input$SpO2
       ), type = "class"
      )

      ifelse(
        cluster == 1,
        paste("Paciente con vulnerabilidad a diabetes. ", gpt()),
        paste("Paciente dentro de los parametros normales.", gpt())
      )
    })
}

# Run the application 
shinyApp(ui, server)
