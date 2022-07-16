# GoskipChallenge

This is the repo for goskip coding challenge. It is a standard phoenix api app with out any db support. There is only access via API.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint `iex -S mix phx.server`

App is now runnng on  [`localhost:4000`](http://localhost:4000).

Use curl or Postman to make api calls to app for example:

```
http://localhost:4000/api/v1/temperature?type=fahrenheit&degrees=90.0
```

returns this response

```
{
    "celsius": 32.22222222222222,
    "fahrenheit": 90.0,
    "kelvin": 305.3722222222222
}
```
Each time a tempterature calculation is requested the result is cached using an agent. All subsequent requests for the same temprature and temprature type are returned from this cache

If an unkown temperature is used, for ex

```
http://localhost:4000/api/v1/temperature?type=foo&degrees=35.0
```

This is the response returned

```
{
    "error": "Unknown type of temperature"
}
```

To interact with the agent, use the following functions

```
<!-- to list values i cache -->
iex>TempStateAgent.value()

<!-- to add items to cache -->
iex>TempStateAgent.add_item(degrees, type, result)

<!-- to find item in cache -->
iex>TempStateAgent.find_items(degrees, type)
```

## Caveats/Additional info

  * Currently temprature must be specified as a float and not an integer. for ex 15.0 not 15. Code to convert from int to float is currently not there..
  