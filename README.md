# plugfieldapi

This package contains function to access the [Plugfield](https://portal.plugfield.com.br/) API and retrieve data from weather stations.

## Instalation

```r
remotes::install_github("rfsaldanha/plugfieldapi")
```

## Login

To retrieve data from weather stations you need to be logged in. You will need an username, password and the x-api-key, provided by Plugfield. You may pass this information manually to the `login()` function, or store it at the renviron file (`usethis::edit_r_environ()`), using the keys `plugfield_username`, `plugfield_password` and `plugfield_x_api_key`.

Then, use the login function once, per session.

```r
login()
```

If you forget to login, the data retrieval will try login automatically, using the renviron keys.

## Devices and sensors

Use the `device_list` function to retrieve a list of devices connected to your account. Then, with a device id, use the function `device_info` to retrieve information of a specific device and the `device_sensors` function to get a table of sensors that are available in a specific device.

## Retrieve data

You may use the functions `data_daily` and `data_hourly` to retrieve time-aggregated data, or the function `data_sensor` to retrieve granular data from a specific sensor.

## API usage limits
This package respects the API restriction of 5 requests per second.