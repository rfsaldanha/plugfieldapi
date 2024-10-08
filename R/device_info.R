#' Device info
#'
#' Retrieve information for a specific device, including last updated data for a dashboard.
#'
#' @param deviceId integer. A device identification code (id).
#'
#' @return a list.
#' @export
device_info <- function(deviceId){
  # Try to login
  if(!check_login()){
    login()
  }

  # Request specification
  req <- httr2::request(base_url = server_url) |>
    httr2::req_url_path("device") |>
    httr2::req_url_path_append(deviceId) |>
    httr2::req_headers("Content-Type" = "application/json") |>
    httr2::req_headers("Authorization" = the$access_token) |>
    httr2::req_headers("x-api-key" = the$x_api_key) |>
    httr2::req_throttle(rate = throttle_rate, realm = server_url) |>
    httr2::req_retry(max_tries = retry_max_tries)

  # Request perform
  resp <- req |>
    httr2::req_perform()

  # Response to list
  res <- resp |> httr2::resp_body_json()

  return(res)
}
