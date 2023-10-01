# Configuración del documento
options(
  knitr.table.format = "html",
  knitr.table.css = "font-size: 24pt;",
  knitr.table.bg = "#F5F5F5"
)

# Cargar paquetes
library(tidyverse)
library(ggplot2)
library(plotly)

# Configuración de la visualización de datos
theme_set(theme_minimal(base_size = 18))

# Cargar datos
glucose <- read_csv("data/glucose.csv")
oximetry <- read_csv("data/Oximetry.csv", col_types = cols())
bloodPressure <- read_csv("data/bloodPressure.csv", col_types = cols())
imc <- read_csv("data/Weight_Height.csv", col_types = cols())

# Función para determinar si es mañana o tarde
is_morning <- function(datetime) {
  hour <- lubridate::hour(datetime)
  ifelse(hour >= 6 & hour < 12, TRUE, FALSE)
}

# Análisis de datos para glucosa
glucose$Date <- lubridate::mdy_hm(glucose$Date)
glucose$is_morning <- ifelse(is_morning(glucose$Date), "Morning", "Afternoon")

# Análisis de datos para oximetría
oximetry$Date <- lubridate::mdy_hm(oximetry$Date)

# Análisis de datos para presión arterial
bloodPressure$Date <- lubridate::mdy_hm(bloodPressure$Date)

# Análisis de datos para IMC
imc$Date <- lubridate::mdy_hm(imc$Date)

# Eliminar outliers de presión arterial
bloodPressure <- bloodPressure %>%
  filter(Systolic > 0 & Diastolic > 0 & AvBloodPressure > 0 & HeartRate > 0)

# Unir los datos en una tabla
diabetes <- glucose %>%
  inner_join(oximetry, by = c("Patient", "Date")) %>%
  inner_join(bloodPressure, by = c("Patient", "Date")) %>%
  inner_join(imc, by = c("Patient", "Date")) %>%
  select(-Patient, -is_morning)

diabetes <- diabetes %>%
  mutate(Date = as.numeric(Date))

scaled <- scale(diabetes)
ggplotly(ggcorrplot(cor(scaled)))

