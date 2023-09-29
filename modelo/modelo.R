blood <- read_csv("data/bloodPressure.csv")
glucose <- read_csv("data/glucose.csv")
oximetry <- read_csv("data/oximetry.csv")
wh <- read_csv("data/Weight_Height.csv")

all <- glucose %>%
  inner_join(blood, by = c("Patient", "Date")) %>%
  inner_join(oximetry, by = c("Patient", "Date")) %>%
  inner_join(wh, by = c("Patient", "Date"))

sum(is.na(all))

data_scaled <- scale(all %>% select(-c(Patient, Date)))

PCA <- prcomp(data_scaled)
componentes_seleccionados <- PCA$sdev > 1.02
componentes_principales <- PCA$x[, componentes_seleccionados]

componentes_principales <- as.data.frame(componentes_principales)
data_plot <- data.frame(PC1 = componentes_principales$PC1,
                        PC2 = componentes_principales$PC2)

model <- kmeans(componentes_principales, 3, iter.max = 1000, nstart = 25, algorithm = "Lloyd")

# asignar el cluster a los datos
data_with_clusters <- cbind(data_plot, Cluster = model$cluster)
centroides <- as.data.frame(model$centers)

ggplot(data_with_clusters, aes(x = PC1, y = PC2, color = factor(Cluster))) +
  geom_point() +
  geom_point(data = centroides, aes(x = PC1, y = PC2),
             color = "black", size = 3, shape = 17) +
  labs(x = "Componente Principal 1", y = "Componente Principal 2",
       title = "Gráfico de Componentes Principales con Clusters K-Means") +
  scale_color_discrete(name = "Cluster")