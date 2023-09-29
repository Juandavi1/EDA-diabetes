to_seconds <- function(dates) {

  # Iterar sobre el vector de fechas
  for (i in seq_along(dates)) {

    # Formatear la fecha para los dos formatos
    formatted_date <- strptime(dates[i], "%d/%m/%Y %H:%M")
    if (is.na(formatted_date)) {
      formatted_date <- strptime(dates[i], "%m/%d/%Y %H:%M")
    }

    # Obtener la hora
    hour <- formatted_date$hour
    min <- formatted_date$min

    # Pasar la hora a segundos del día
    segundos_del_dia <- 60 * 60 * hour + min * 60

    # Guardar los segundos del día
    dates[i] <- segundos_del_dia
  }

  # Devolver el vector de segundos del día
  return(dates)
}

is_morning <- function(dates) {

  # Iterar sobre el vector de fechas
  for (i in seq_along(dates)) {

    # Formatear la fecha para los dos formatos
    formatted_date <- strptime(dates[i], "%d/%m/%Y %H:%M")
    if (is.na(formatted_date)) {
      formatted_date <- strptime(dates[i], "%m/%d/%Y %H:%M")
    }

    # Obtener la hora
    hour <- formatted_date$hour

    # Si la hora es inferior a 12, es mañana.
    dates[i] <- hour < 12
  }

  # Devolver el vector de segundos del día
  return(dates)
}
