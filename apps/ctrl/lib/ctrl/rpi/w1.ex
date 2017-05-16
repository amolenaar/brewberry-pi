defmodule Ctrl.Rpi.W1 do
  @moduledoc "Onewire connection"

  def base_dir, do: "/sys/bus/w1/devices/"

  def sensor do
    base_dir()
    |> File.ls!
    |> Enum.filter(&(String.starts_with?(&1, "28-")))
    |> List.first
  end

  def read(sensor) do
    sensor_data = File.read!("#{base_dir()}#{sensor}/w1_slave")
    {temp, _} = ~r/t=(\d+)/
        |> Regex.run(sensor_data)
        |> List.last
        |> Float.parse
    temp / 1000
  end
end
