# Configuración del documento
options(
  knitr.table.format = "html",
  knitr.table.css = "font-size: 24pt;",
  knitr.table.bg = "#F5F5F5"
)

install.packages("rpart.plot")


# Cargar paquetes
library(tidyverse)
library(ggplot2)
library(plotly)
library(caret)
library(rpart)
library(caret)
library(ggcorrplot)
library(factoextra)

library(rpart.plot)
library(rpart)

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
  select(-Patient, -is_morning) %>%
  select(AvBloodPressure, IMC, Systolic, Weight)

diabetes <- diabetes %>%
  mutate(Date = as.numeric(Date))

ggplotly(ggcorrplot(cor(diabetes)))


wss <- 0
for (i in 1:10) {
  km.iris <- kmeans(scale(diabetes %>% select(AvBloodPressure, IMC, Systolic, Weight)), centers = i, nstart=25, iter.max = 50)
  wss[i] <- km.iris$tot.withinss
}

plot(1:10, wss, type = "b", 
     xlab = "Numero de Clusters", 
     ylab = "Suma de cuadrados entre grupos")


model <- kmeans(scale(diabetes), 4, iter.max = 100, algorithm = "Lloyd")
diabetes_with_clusters <- cbind(diabetes, Cluster = factor(model$cluster))


particion <- createDataPartition(diabetes_with_clusters$Cluster, p = 0.7, list = FALSE)
train <- diabetes_with_clusters[particion, ]
test <- diabetes_with_clusters[-particion, ]

tree_model <- rpart(Cluster ~ ., data = train, method = "class")
plotcp(tree_model)
prp(tree_model)

y_pred <- predict(tree_model, newdata = test, type = "prob")
y_pred_cluster <- if_else(y_pred[,2] > 0.5, 2, 1)
y_pred_cluster <- factor(y_pred_cluster, levels = levels(test$Cluster))

ggplotly(fviz_nbclust(scale(diabetes), kmeans, method = "silhouette", k.max = 10))

class(model %>% select(betweenss))

ggplotly(ggplot(as.data.frame(diabetes_with_clusters), aes(x = IMC, fill = Cluster)) +
           geom_histogram(color = "white") +
           facet_wrap(~Cluster) +
           geom_vline(xintercept = 30, color = "red", linetype = "dashed", size = 1, show.legend = TRUE) +
           ggtitle("K-Means Clustering en Componentes Principales"))

cf <- confusionMatrix(test$Cluster, y_pred_cluster)
ggplotly(fourfoldplot(as.table(cf),color=c("red","green"),main = "Confusion Matrix"))

silhouette_score <- silhouette(model$cluster, dist(diabetes_with_clusters))
silhouette_score
plot(silhouette_score)

plot(silhouette_score,
     xlab = "Coeficiente de silueta",
     ylab = "Número de cluster",
     main = "Gráfico de silueta")
abline(h = 0.5, lty = 2)


plot(diabetes_with_clusters, col =  model$cluster, main="Glucose")


saveRDS(tree_model, "diabetes.rds")

set.seed(123)

fviz_nbclust(scale(diabetes), kmeans, method = "silhouette",)

PCA <- prcomp(scale(diabetes))
ggplotly(fviz_cos2(PCA, choice = "var", axes = 1:2))

silhouette_score <- cluster.stats(dist(diabetes), model$cluster)
mean(silhouette_score)

