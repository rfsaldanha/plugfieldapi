#' Device sensors
#'
#' Retrieve sensors available from a device id.
#'
#' @param deviceId integer. A device identification code (id).
#'
#' @return a tibble.
#' @export
device_sensors <- function(deviceId){
  # Try to login
  if(!check_login()){
    login()
  }

  # Retrieve device info
  res <- device_info(deviceId)

  res2 <- res$sensorList |>
    purrr::reduce(dplyr::bind_rows)

  return(res2)
}
