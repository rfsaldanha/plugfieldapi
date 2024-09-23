check_login <- function(){
  if(any(!is.null(the$username), !is.null(the$password), !is.null(the$x_api_key), !is.null(the$access_token))){
    return(TRUE)
  } else {
    return(FALSE)
  }
}