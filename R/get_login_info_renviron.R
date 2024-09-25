get_login_info_renviron <- function(){
  res <- list(
    username = Sys.getenv("plugfield_username"),
    password = Sys.getenv("plugfield_password"),
    x_api_key = Sys.getenv("plugfield_x_api_key")
  )

  if(res$password == ""){
    cli::cli_abort("Plugfield username not provided and not found on renviron. Please provide it using the plugfield_username, plugfield_password and plugfield_x_api_key values on environ.")
  }

  if(res$username == ""){
    cli::cli_abort("Plugfield password not provided and not found on renviron. Please provide it using the plugfield_username, plugfield_password and plugfield_x_api_key values on environ.")
  }

  if(res$x_api_key == ""){
    cli::cli_abort("Plugfield x-api-key not provided and not found on renviron. Please provide it using the plugfield_username, plugfield_password and plugfield_x_api_key values on environ.")
  }

  return(res)
}
