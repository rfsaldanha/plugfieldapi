device_list <- function(){
  # Try to login
  if(!check_login()){
    login()
  }

  # Request specification
  req <- httr2::request(base_url = server_url) |>
    httr2::req_url_path("device") |>
    httr2::req_headers("Content-Type" = "application/json") |>
    httr2::req_headers("Authorization" = the$access_token) |>
    httr2::req_headers("x-api-key" = the$x_api_key) |>
    httr2::req_throttle(rate = throttle_rate, realm = server_url) |>
    httr2::req_retry(max_tries = retry_max_tries)
  
  # Request perform
  resps <- httr2::req_perform_iterative(
    req |> httr2::req_url_query(limit = 1),
    next_req = httr2::iterate_with_offset(
      "page_index",
      resp_pages = function(resp) httr2::resp_body_json(resp)$pagination$totalPages
    ),
    max_reqs = Inf
  )

  # Responses to list
  res <- resps |> httr2::resps_successes() |>
    httr2::resps_data(\(resp) httr2::resp_body_json(resp))

  return(res$deviceList)
}