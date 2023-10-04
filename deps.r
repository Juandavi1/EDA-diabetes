# Verifica si el paquete "tidyverse" está instalado, y si no, instálalo.
if (!require(tidyverse)) {
  install.packages("tidyverse")
}

# Repite este proceso para otros paquetes
if (!require(ggplot2)) {
  install.packages("ggplot2")
}

if (!require(ggcorrplot)) {
  install.packages("ggcorrplot")
}

if (!require(patchwork)) {
  install.packages("patchwork")
}

if (!require(caret)) {
  install.packages("caret")
}

if (!require(ggthemes)) {
  install.packages("ggthemes")
}

if (!require(Metrics)) {
  install.packages("Metrics")
}

if (!require(GGally)) {
  install.packages("GGally")
}

if (!require(shiny)) {
  install.packages("shiny")
}

if (!require(kableExtra)) {
  install.packages("kableExtra")
}

if (!require(plotly)) {
  install.packages("plotly")
}

if (!require(rpart.plot)) {
  install.packages("rpart.plot")
}

if (!require(fpc)) {
  install.packages("fpc")
  library(fpc)
}

if (!require(FactoMineR)) {
  install.packages("FactoMineR")
  library(FactoMineR)
}

# Luego, carga los paquetes
library(rpart.plot)
library(rpart)
library(dplyr)
library(plotly)
library(kableExtra)
library(tidyverse)
library(ggplot2)
library(ggcorrplot)
library(patchwork)
library(caret)
library(ggthemes)
library(Metrics)
library(GGally)
library(gbm)
library(shiny)
library(factoextra)
library(lubridate)
library(cluster)

