get_login_info_renviron <- function(){
  res <- list(
    username = Sys.getenv("plugfield_username"),
    password = Sys.getenv("plugfield_password"),
    x_api_key = Sys.getenv("plugfield_x_api_key")
  )

  if(res$password == ""){
    cli::cli_abort("Pugfield username not provided and not found on renviron. Provide it using the plugfield_username value on environ.")
  }

  if(res$username == ""){
    cli::cli_abort("Pugfield password not provided and not found on renviron. Provide it using the plugfield_password value on environ.")
  }

  if(res$x_api_key == ""){
    cli::cli_abort("Pugfield x-api-key not provided and not found on renviron. Provide it using the plugfield_x_api_key value on environ.")
  }

  return(res)
}