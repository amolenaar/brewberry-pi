defmodule Ctrl.Rpi.W1 do

  def base_dir, do: "/sys/bus/w1/devices/"

  def sensor do
    File.ls!(base_dir())
    |> Enum.filter(&(String.starts_with?(&1, "28-")))
    |> List.first
  end

  def read(sensor) do
    sensor_data = File.read!("#{base_dir()}#{sensor}/w1_slave")
    {temp, _} = Regex.run(~r/t=(\d+)/, sensor_data)
        |> List.last
        |> Float.parse
    temp / 1000
  end
end
