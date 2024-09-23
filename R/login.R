login <- function(username = NULL, password = NULL, x_api_key = NULL){
  # Check if is already logged in
  if(check_login()){
    cli::cli_abort("You are already logged in.")
  }

  
  # Try to get login information from renviron
  if(all(is.null(username), is.null(password), is.null(x_api_key))){
    login_info <- get_login_info_renviron()
    username <- login_info$username
    password <- login_info$password
    x_api_key <- login_info$x_api_key
  }
  
  # Request specification
  req <- httr2::request(base_url = server_url) |>
    httr2::req_url_path_append("/login") |>
    httr2::req_headers("x-api-key" = x_api_key) |>
    httr2::req_body_json(
      list(
        username = username,
        password = password
      )
    ) |>
      httr2::req_throttle(rate = throttle_rate, realm = server_url) |>
      httr2::req_retry(max_tries = retry_max_tries)

  # Request perform
  resp <- req |> 
    httr2::req_perform()

  # Response to list
  res <- resp |> httr2::resp_body_json()

  # Assign values to environment (created at startup.R file)
  the$username <- username
  the$password <- password
  the$x_api_key <- x_api_key
  the$access_token <- res$access_token

  # Check environment
  if(any(is.null(the$username), is.null(the$password), is.null(the$x_api_key), is.null(the$access_token))){
    cli::cli_abort("The login failed.")
  } else {
    cli::cli_alert_success("You are logged in!")
  }
}