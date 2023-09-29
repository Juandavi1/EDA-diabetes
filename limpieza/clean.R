# relación de datos entre bloodPressure.csv y glucose.csv
blood <- read_csv("data/bloodPressure.csv")
glucose <- read_csv("data/glucose.csv")

# total pacientes
data.frame(
  blood = length(unique(blood$Patient)),
  glucose = length(unique(glucose$Patient))
)

blood[c('Fecha', 'Hora')] <- str_split_fixed(blood$Date, " ", 2)
glucose[c('Fecha', 'Hora')] <- str_split_fixed(glucose$Date, " ", 2)


nrow(glucose %>% inner_join(blood, by = c("Patient", "Date")))

# split del vector glucose$Date para separar la fecha y el día en dos columnas
as.Date(glucose$Date)


length(glucose$Date)
date_split <- strsplit(glucose$Date, " ")

glucose$fecha <- as.Date(date_split, format = "%m/%d/%Y")
glucose$hora <- as.POSIXct(date_split[2], format = "%H:%M")

# se identifica los pacientes que no tienen toma de glucosa
missingBlood <- anti_join(blood, glucose, by = c("Patient"))
missingBlood

# 7 pacientes que tienen toma de presión sanguinea y no tienen tomas de glucosa
nrow(blood[blood$Patient %in% missingBlood$Patient,])
nrow(glucose[glucose$Patient %in% missingBlood$Patient,])
blood[blood$Patient %in% missingBlood$Patient,]

# todos los pacientes que tienen tomas de glucosa tienen tomas de presión sanguinea
missingBlood <- setdiff(glucose$Patient, blood$Patient)
nrow(glucose[glucose$Patient %in% missingBlood,])
nrow(blood[blood$Patient %in% missingBlood,])
blood[blood$Patient %in% missingBlood,]

# se identifica los pacientes que tienen toma de glucosa y presión sanguinea
join <- glucose %>% inner_join(blood, by = c("Patient", "Date"))

anti_join(glucose, blood , by = c("Patient"))

blood[blood$Patient == 81,]
x[x$Patient == 81,]
