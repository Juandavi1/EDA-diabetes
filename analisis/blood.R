blood <- read_csv("data/bloodPressure.csv")
head(blood)

blood %>% filter(Systolic <5)

# total de pacientes.
length(unique(blood$Patient))

# Valores faltantes
sum(is.na(blood))
sum(is.null(blood))

# Se observan pacientes con oximetría muy alta y muy baja.
summary(blood)

# Grafico de correlación entre SpO2 y HeartRate
ggcorrplot(cor(select(blood, -Patient, -Date)))

# Distribución de Systolic
ggplot(blood, aes(x = Systolic)) +
  geom_histogram(binwidth = 1, color="#092933", fill="#1E5F3F", alpha=0.7) +
  labs(x = "Systolic", y = "Frecuencia") +
  theme_bw() +
  theme_fivethirtyeight() +
  geom_vline(xintercept = 130, color = "red", linetype = "dashed", size = 1, show.legend = TRUE) +
  ggtitle("Distribución de Systolic")

# Distribución de Diastolic
ggplot(blood %>% arrange(Patient,Date), aes(x = Diastolic)) +
  geom_histogram(binwidth = 1, color="#092933", fill="#1E5F3F", alpha=0.7) +
  labs(x = "Diastolic", y = "Frecuencia") +
  theme_bw() +
  theme_fivethirtyeight() +
  geom_vline(xintercept = 80, color = "red", linetype = "dashed", size = 1, show.legend = TRUE) +
  ggtitle("Distribución de Diastolic")

# Distribución de AvBloodPressure
ggplot(blood, aes(x = AvBloodPressure)) +
  geom_histogram(binwidth = 1, color="#092933", fill="#1E5F3F", alpha=0.7) +
  labs(x = "AvBloodPressure", y = "Frecuencia") +
  theme_bw() +
  theme_fivethirtyeight() +
  geom_vline(xintercept = 100, color = "red", linetype = "dashed", size = 1, show.legend = TRUE) +
  ggtitle("Distribución de AvBloodPressure")

# Distruibución de HeartRate
ggplot(blood, aes(x = HeartRate)) +
  geom_histogram(binwidth = 1, color="#092933", fill="#1E5F3F", alpha=0.7) +
  labs(x = "HeartRate", y = "Frecuencia") +
  theme_bw() +
  theme_fivethirtyeight() +
  geom_vline(xintercept = 100, color = "red", linetype = "dashed", size = 1, show.legend = TRUE) +
  ggtitle("Distribución de HeartRate")


ggplotly(ggpairs(
  blood,
  columns = c("Systolic", "Diastolic", "AvBloodPressure", "HeartRate"),
  title = "Gráfico de correlación entre variables",
))