wh <- read_csv("data/Weight_Height.csv", col_types = type())
head(wh)

wh[wh$Patient == 663, ]

# total de pacientes.
length(unique(wh$Patient))

# Valores faltantes
sum(is.na(wh))
sum(is.null(wh))

summary(wh)

# Grafico de correlación entre SpO2 y HeartRate
ggcorrplot(cor(select(wh, -Patient, -Date)))

ggpairs(
  wh,
  columns = c("Weight", "Height", "IMC"),
  title = "Gráfico de correlación entre variables",
) + theme_bw()

# Distribución de Weight
ggplot(wh, aes(x = Weight)) +
  geom_histogram(binwidth = 1, color="#092933", fill="#1E5F3F", alpha=0.7) +
  labs(x = "Weight", y = "Frecuencia") +
  theme_bw() +
  theme_fivethirtyeight() +
  ggtitle("Distribución de Weight")

# Distribución de Height
ggplot(wh, aes(x = Height)) +
  geom_histogram(binwidth = 1, color="#092933", fill="#1E5F3F", alpha=0.7) +
  labs(x = "Height", y = "Frecuencia") +
  theme_bw() +
  theme_fivethirtyeight() +
  ggtitle("Distribución de Height")

# Distribución de IMC
ggplot(wh, aes(x = IMC)) +
  geom_histogram(binwidth = 1, color="#092933", fill="#1E5F3F", alpha=0.7) +
  labs(x = "BMI", y = "Frecuencia") +
  theme_bw() +
  theme_fivethirtyeight() +
  geom_vline(xintercept = 25, color = "red", linetype = "dashed", size = 1, show.legend = TRUE) +
  ggtitle("Distribución de BMI")