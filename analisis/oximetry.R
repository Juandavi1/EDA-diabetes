# SpO2 es la abreviatura de "saturación de oxígeno en sangre periférica".
oximetry <- read_csv("data/oximetry.csv")

head(oximetry)

# total de pacientes.
length(unique(oximetry$Patient))

# Valores faltantes
sum(is.na(oximetry))
sum(is.null(oximetry))

# Se observan pacientes con oximetría muy alta y muy baja.
summary(oximetry)

# Grafico de correlación entre SpO2 y HeartRate
ggcorrplot(cor(select(oximetry, -Patient, -Date)))

ggcorrplot(cor(select(oximetry, -Patient, -Date)))

ggpairs(
  oximetry,
  columns = c("SpO2", "HeartRate"),
  title = "Gráfico de correlación entre variables",
)

# Distribución de SpO2
ggplot(oximetry, aes(x = SpO2)) +
  geom_histogram(binwidth = 1, color="#092933", fill="#1E5F3F", alpha=0.7) +
  labs(x = "SpO2", y = "Frecuencia") +
  theme_bw() +
  theme_fivethirtyeight() +
  ggtitle("Distribución de SpO2")

# Distribución de HeartRate
ggplot(oximetry, aes(x = HeartRate)) +
  geom_histogram(binwidth = 1, color="#092933", fill="#1E5F3F", alpha=0.7) +
  labs(x = "HeartRate", y = "Frecuencia") +
  theme_bw() +
  theme_fivethirtyeight() +
  ggtitle("Distribución de HeartRate")
