data_hourly <- function(deviceId, begin, end, as_list = FALSE){
  # Try to login
  if(!check_login()){
    login()
  }  
  
  # Request specification
  req <- httr2::request(base_url = server_url) |>
    httr2::req_url_path("data/hourly") |>
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

  # Response to data frame
  res <- resp |>
    httr2::resp_body_json()

  # List or data frame
  if(as_list){
    return(res)
  } else {
    res2 <- res |>
      purrr::reduce(dplyr::bind_rows)

    res3 <- res2 |>
      dplyr::select(-"additionalSensors") |>
      dplyr::distinct()

    res4 <- res2 |>
      tidyr::unnest_wider(col = additionalSensors) |>
      tidyr::pivot_wider(
        id_cols = id,
        names_from = sensorName,
        values_from = sensorValue
      ) |>
      janitor::clean_names()

    res5 <- dplyr::inner_join(res3, res4, by = "id")

    return(res5)
  }
}