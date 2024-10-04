#' Data from sensor
#'
#' Retrieve data from a sensor on a device
#'
#' @param deviceId integer. A device identification code (id).
#' @param sensor integer. A sensor code, as informed on [device_sensors()].
#' @param time character. Start date and time. If not provided, the function will return data from the last day. Use the format `day/month/year hour:minute:second`. Example: `20/09/2024 09:59:59`
#' @param timeMax character. End date and time. If not provided, the function will return data from the last day. Use the format `day/month/year hour:minute:second`. Example: `20/09/2024 09:59:59`
#'
#' @return a tibble.
#' @export
data_sensor <- function(deviceId, sensor, time = NULL, timeMax = NULL){
  # Try to login
  if(!check_login()){
    login()
  }

  # Request specification
  req <- httr2::request(base_url = server_url) |>
    httr2::req_url_path("data/sensor") |>
    httr2::req_url_query(device = deviceId) |>
    httr2::req_url_query(sensor = sensor) |>
    httr2::req_headers("Content-Type" = "application/json") |>
    httr2::req_headers("Authorization" = the$access_token) |>
    httr2::req_headers("x-api-key" = the$x_api_key) |>
    httr2::req_throttle(rate = throttle_rate, realm = server_url) |>
    httr2::req_retry(max_tries = retry_max_tries)

  # Request additional specifications

  # time
  if(!is.null(time)){
    # Convert time to miliseconds
    time <- lubridate::as_datetime(time, format = "%d/%m/%Y %H:%M:%S")
    time <- as.numeric(time)*1000

    req <- req |>
      httr2::req_url_query(time = time)
  }

  # timeMax
  if(!is.null(timeMax)){
    # Convert time to miliseconds
    timeMax <- lubridate::as_datetime(timeMax, format = "%d/%m/%Y %H:%M:%S")
    timeMax <- as.numeric(timeMax)*1000

    req <- req |>
      httr2::req_url_query(timeMax = timeMax)
  }

  # Resquest perform without pagination
  res <- httr2::req_perform(req) |>
    httr2::resp_body_json()

  # Check for paginated results
  if(res$pagination$totalPages > 1){
    # Request perform with pagination
    resps <- httr2::req_perform_iterative(
      req |> httr2::req_url_query(limit = 1),
      next_req = httr2::iterate_with_offset(
        "page_index",
        resp_pages = function(resp) httr2::resp_body_json(resp)$pagination$totalPages
      ),
      max_reqs = Inf
    )

    # Response to list
    res <- resps |> httr2::resps_successes() |>
      httr2::resps_data(\(resp) httr2::resp_body_json(resp))
  }

  if(length(res$data) == 0){
    cli::cli_abort("No data available from sensor.")
  } else if(length(res$data) == 1){
    res2 <- res$data |> 
      dplyr::bind_rows()
  } else {
      res2 <- res$data |>
        purrr::reduce(dplyr::bind_rows)
  }

  res3 <- res2 |> 
    dplyr::mutate(
      # Treat date and time fieds
      time = lubridate::as_datetime(time/1000)
    ) |>
    # Format variable names
    janitor::clean_names()
  
  return(res3)
}
