#' Device last update time
#'
#' Retrieve device last update time
#'
#' @param deviceId integer. A device identification code (id).
#'
#' @return a date.
#' @export
device_last_update <- function(deviceId){
  tmp <- plugfieldapi::device_info(deviceId)
  res <- lubridate::as_datetime(tmp$lastUpdateTimestamp/1000)
  return(res)
}