defmodule GoskipChallengeWeb.API.V1.TemperatureController do
  use GoskipChallengeWeb, :controller
  alias GoskipChallenge.TempStateAgent

  @valid_types ["celsius", "fahrenheit", "kelvin"]
  # ensure type is enum ( celsius, fahrenheit , kelvin) anything else is wring

  def index(conn, %{"type" => type, "degrees" => degrees}) do
    # params degrees=20, type = 'celsius' , 'fahrenheit', kelvin'
    if Enum.member?(@valid_types, type) do
      case maybe_fetch_from_cache(type, String.to_float(degrees)) do
        [] ->
          IO.puts "adding item to cacheh"
          { celsius, fahrenheit, kelvin } = calc_temp(type, String.to_float(degrees))
          resp = %{"celsius" => celsius,"fahrenheit" => fahrenheit,  "kelvin" => kelvin}

          # add this value to cache
          TempStateAgent.add_item(String.to_float(degrees), type, resp)
          send_response(conn, resp)
        temp ->
          IO.puts "found item in cache"
          IO.inspect temp
          send_response(conn, temp[:conversions])
      end
    else
      resp = %{"error" => "Unknown type of temperature"}
      send_response(conn, resp)
    end
  end


  # private methods
  defp maybe_fetch_from_cache(type, degrees) do
    TempStateAgent.find_items(type, degrees)
  end

  defp send_response(conn, resp) do
    conn
      |> put_status(200)
      |> json(resp)
  end

  defp calc_temp( "celsius", degrees) do
    # celsius to fahrenheit  -  0°C × 9/5) + 32 = 32°F
    # celsius to kelvin -  0°C + 273.15 = 273.15K
    kelvin = degrees + 273.15
    fahrenheit = (degrees * 9/5) + 32
    {degrees, fahrenheit, kelvin}
  end

  defp calc_temp( "kelvin", degrees) do
    # kelvin to celsius
    celsius =  degrees  - 273.15
    # kelvin to fahrenheit
    fahrenheit =  (degrees - 273.15) * 9/5 + 32
    {celsius, fahrenheit, degrees}
  end

  defp calc_temp( "fahrenheit", degrees) do
    # fahrenheit to celcius
    celsius = (degrees - 32) * 5/9
    # fahrenheit to kelvin
    kelvin = ( degrees - 32) * 5/9 + 273.15
    {celsius , degrees, kelvin}
  end

  defp calc_temp( _, _degrees) do
    IO.puts "calculate unknown"
  end

end
