# Server base url
server_url <- "https://prod-api.plugfield.com.br"

# API limits
throttle_rate <- 5 #seconds
retry_max_tries <- 3

# Create enviroment to handle login information
the <- new.env(parent = emptyenv())
