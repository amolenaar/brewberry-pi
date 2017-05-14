defmodule Ctrl.ControllerServer do
  @moduledoc "The Controller process"
  use GenServer

  alias Ctrl.Sample
  alias Ctrl.BrewHouse
  alias Ctrl.Controller

  @heater_mod Application.get_env(:ctrl, :heater)
  @thermometer_mod Application.get_env(:ctrl, :thermometer)

  ## Client interface

  def start_link(),
    do: GenServer.start_link(__MODULE__, [], [name: __MODULE__])

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

  def init([]) do
    @heater_mod.init()
    {:ok, Controller.new(BrewHouse.new)}
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
    {:noreply, Controller.mash_temperature(controller, new_temp)}
  end

  def handle_cast({:tick, now}, controller) do
    # TODO: move to init
    thermometer_mod = @thermometer_mod
    temp_sensor = thermometer_mod.new

    new_temp = thermometer_mod.read(temp_sensor)
    controller = Controller.update(controller, now, new_temp)
    mode = Controller.mode?(controller)
    on_off = @heater_mod.update(mode)

    sample = %Sample{
      time: now,
      temperature: new_temp,
      heater: on_off,
      mode: mode,
      mash_temperature: Controller.mash_temperature?(controller)
    }

    Ctrl.TimeSeries.update sample.time |> DateTime.to_unix, sample

    {:noreply, controller}
  end

  def handle_call(:mash_temp, _from, controller) do
    {:reply, controller.mash_temp, controller}
  end

  def handle_call(:mode, _from, controller) do
    {:reply, controller.mode, controller}
  end

end
