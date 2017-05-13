defmodule Ctrl.ControllerServer do
  @moduledoc "The Controller process"
  use GenServer

  alias Ctrl.Sample
  alias Ctrl.Controller.Config
  alias Ctrl.Controller


  ## Client interface

  def start_link(config \\ %Config{}, name \\ __MODULE__),
    do: GenServer.start_link(__MODULE__, config, [name: name])

  def resume(controller \\ __MODULE__),
    do: GenServer.cast(controller, :resume)

  def pause(controller \\ __MODULE__),
    do: GenServer.cast(controller, :pause)

  def mash_temperature(controller \\ __MODULE__, new_temp),
    do: GenServer.cast(controller, {:mash_temp, new_temp})

  def mash_temperature?(controller \\ __MODULE__),
    do: GenServer.call(controller, :mash_temp)

  def mode?(controller \\ __MODULE__),
    do: GenServer.call(controller, :mode)


  ## Server callbacks

  def init(config) do
    {:ok, Controller.new(config)}
  end

  @doc "Start the controller."
  def handle_cast(:resume, controller) do
    {:noreply, Controller.resume(controller)}
  end

  @doc "Stop the controller."
  def handle_cast(:pause, controller) do
    {:noreply, Controller.pause(controller)}
  end

  def handle_cast({:mash_temp, new_temp}, controller) do
    {:noreply, Controller.set_mash_temperature(controller, new_temp)}
  end

  def handle_cast({:tick, now}, controller) do
    now = now |> DateTime.to_unix

    thermometer_mod = Application.get_env(:ctrl, :thermometer)
    heater_mod = Application.get_env(:ctrl, :heater)

    temp_sensor = thermometer_mod.new
    heater = heater_mod.new

    new_temp = thermometer_mod.read(temp_sensor)
    controller = Controller.evaluate(controller, now, new_temp)
    {_, heater_state} = heater_mod.update(heater, controller.mode)

    sample = %Sample{
      time: now,
      temperature: new_temp,
      heater: heater_state,
      mode: controller.mode,
      mash_temperature: controller.mash_temp
    }

    Ctrl.TimeSeries.update sample.time, sample

    {:noreply, controller}
  end

  def handle_call(:mash_temp, _from, controller) do
    {:reply, controller.mash_temp, controller}
  end

  def handle_call(:mode, _from, controller) do
    {:reply, controller.mode, controller}
  end

end
