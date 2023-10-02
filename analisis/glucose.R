# un tipo de azúcar simple que es la principal fuente de energía del cuerpo. Se encuentra en los alimentos que comemos y también se produce en el hígado. La glucosa se libera en el torrente sanguíneo y viaja a las células, donde se utiliza para generar energía.

# El rango de glucosa en sangre normal es de 70 a 100 mg/dL. La mayoría de los datos del gráfico se encuentran dentro de este rango.
# El rango de glucosa en sangre elevado es de 100 a 126 mg/dL. Un pequeño número de datos del gráfico se encuentran dentro de este rango.
# El rango de glucosa en sangre diabético es superior a 126 mg/dL. No hay datos del gráfico dentro de este rango.
glucose <- read_csv("data/glucose.csv")


head(glucose)

# total de pacientes
length(unique(glucose$Patient))

# Valores faltantes
sum(is.na(glucose))
sum(is.null(glucose))

# Se observan pacientes con glucosa muy alta y muy baja.
summary(glucose)

install.packages("plotly")
library(plotly)

# Distribución de glucosa
# La mayoría de los pacientes tienen un buen control de sus niveles de glucosa en sangre. Esto se debe a que la mayoría de los datos se encuentran dentro de los rangos normales.
# Hay un pequeño número de pacientes con diabetes que tienen niveles de glucosa en sangre elevados. Estos pacientes pueden tener un mayor riesgo de complicaciones de la diabetes, como enfermedades cardíacas, accidentes cerebrovasculares y ceguera.
p <- ggplot(glucose[glucose$Patient == 2,] %>% arrange(Date) , aes(y = Glucose, x = as.Date(Date))) +
  geom_line(binwidth = 10, color="#0A2F35", fill="#12492F", alpha=0.7, outlier.shape = NA, coef = 2) +
  labs(x = "Glucosa", y = "Frecuencia") +
  theme_clean() +
  ggtitle("Distribución de glucosa")

ggplotly(p)


glucose %>%
  summarise_all(~ sum(is.na(.))) %>%
  gather() %>%
  kable() %>%
  kable_styling(full_width = F, position = "left")


# Distribución de glucosa en la mañana y en la tarde (sin agrupar)
# Los valores de glucosa en sangre son generalmente más altos por la tarde que por la mañana. Esto se debe a que los niveles de insulina suelen ser más bajos por la tarde, lo que dificulta que el cuerpo procese el azúcar de los alimentos.
# Hay un número relativamente pequeño de pacientes con valores de glucosa en sangre elevados por la mañana. Esto sugiere que la mayoría de los pacientes con diabetes tienen un buen control de sus niveles de glucosa en sangre en ayunas.
# Hay un número mayor de pacientes con valores de glucosa en sangre elevados por la tarde. Esto sugiere que los pacientes con diabetes pueden tener dificultades para controlar sus niveles de glucosa en sangre después de comer.
# Se identifica una relación directa entre la glucosa en sangre y la hora del día.
# Los valores de glucosa en sangre son generalmente más altos por la tarde que por la mañana.

glucose$IsMorning <- ifelse(is_morning(glucose$Date), "Morning", "Afternoon")
glucose$IsMorning <- factor(glucose$IsMorning)
CriticalValue <- 126

ggplot(data = glucose %>% arrange(Date) %>% mutate(Date = as.Date(Date)) %>% sample_n(100), aes(y = Glucose, x = Date, color = Patient)) +
  geom_line() +
  labs(x = "Glucosa", y = "Frecuencia") +
  ggtitle("Distribución de glucosa por la mañana y por la tarde") +
  theme_fivethirtyeight()

glucose[c('Fecha', 'Hora')] <- str_split_fixed(glucose$Date, " ", 2)

# Validación de formato de la fecha
# tomar un formato al azar
glucose[glucose$Patient == 1410,]

d <- strptime(glucose$Date, format="%m/%d/%Y %H:%M")
as.Date(d)
# total de fechas que no cumplen con el formato
sum(is.na(as.numeric(as.Date(d))))


imc <- imc %>%
  mutate(Date = parse_date_time(Date, orders = "mdy HM")) %>%
  filter(Height < 3)

