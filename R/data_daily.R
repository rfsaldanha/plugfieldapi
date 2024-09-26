#' Daily aggregated data
#'
#' @param deviceId integer. A device identification code (id).
#' @param begin character. Start date. Use the format `day/month/year`. Example: `20/09/2024`
#' @param end character. End date. Use the format `day/month/year`. Example: `20/09/2024`
#' @param as_list logical. If `TRUE` the function will return a list, otherwise, a tibble.
#'
#' @return a list or a tibble, depending on the `as_list` argument.
#' @export
#' @importFrom rlang .data
data_daily <- function(deviceId, begin, end, as_list = FALSE){
  # Try to login
  if(!check_login()){
    login()
  }

  # Request specification
  req <- httr2::request(base_url = server_url) |>
    httr2::req_url_path("data/daily") |>
    httr2::req_url_query(device = deviceId) |>
    httr2::req_url_query(begin = begin) |>
    httr2::req_url_query(end = end) |>
    httr2::req_headers("Content-Type" = "application/json") |>
    httr2::req_headers("Authorization" = the$access_token) |>
    httr2::req_headers("x-api-key" = the$x_api_key) |>
    httr2::req_throttle(rate = throttle_rate, realm = server_url) |>
    httr2::req_retry(max_tries = retry_max_tries)

  # Request perform
  resp <- req |>
    httr2::req_perform()

  # Response to list
  res <- resp |>
    httr2::resp_body_json()

  # List or data frame
  if(as_list){
    # Return list
    return(res)
  } else {
    # Return data frame

    # List to data frame
    res2 <- res |>
      purrr::reduce(dplyr::bind_rows)

    # Isolate sensors and remove duplicates
    res3 <- res2 |>
      dplyr::select(-"additionalSensors") |>
      dplyr::distinct()

    # Additional sensors values
    res4 <- res2 |>
      tidyr::unnest_wider(col = "additionalSensors") |>
      tidyr::pivot_wider(
        id_cols = "id",
        names_from = "sensorName",
        values_from = "sensorValue"
      )

    # Additional sensors counts
    res5 <- res2 |>
      tidyr::unnest_wider(col = "additionalSensors") |>
      dplyr::mutate(sensorName = paste(.data$sensorName, "count")) |>
      tidyr::pivot_wider(
        id_cols = "id",
        names_from = "sensorName",
        values_from = "sensorValueCount"
      )

    # Join data
    res6 <- dplyr::inner_join(res3, res4, by = "id") |>
      dplyr::left_join(res5, by = "id") |>
      # Treat date and time fieds
      dplyr::mutate(
        localDateTime = lubridate::as_datetime(.data$localDateTime),
        timestamp = lubridate::as_datetime(.data$timestamp/1000)
      ) |>
      # Format variable names
      janitor::clean_names()

    return(res6)
  }
}
