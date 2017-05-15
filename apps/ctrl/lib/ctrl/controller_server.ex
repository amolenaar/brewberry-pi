defmodule Ctrl.ControllerServer do
  @moduledoc "The Controller process"
  use GenServer

  alias Ctrl.Sample
  alias Ctrl.BrewHouse
  alias Ctrl.Controller
  alias Ctrl.ControllerServer

  @heater_mod Application.get_env(:ctrl, :heater)
  @thermometer_mod Application.get_env(:ctrl, :thermometer)

  ## Client interface

  @spec start_link() :: {:ok, pid}
  def start_link(),
    do: GenServer.start_link(__MODULE__, [], [name: __MODULE__])

  @spec resume(GenServer.server) :: :ok
  def resume(controller \\ __MODULE__),
    do: GenServer.cast(controller, :resume)

  @spec pause(GenServer.server) :: :ok
  def pause(controller \\ __MODULE__),
    do: GenServer.cast(controller, :pause)

  @spec mash_temperature(GenServer.server, float | integer) :: :ok
  def mash_temperature(controller \\ __MODULE__, new_temp),
    do: GenServer.cast(controller, {:mash_temp, new_temp})


  ## Server callbacks

  defstruct [:controller, :thermometer, :heater]

  @typep t :: %ControllerServer{
    controller: Controller.t,
    thermometer: {module, Thermometer.t},
    heater: {module, Heater.t}
  }

  @spec init(any) :: {:ok, t}
  def init(_opts) do
    heater_mod = @heater_mod
    thermometer_mod = @thermometer_mod
    {:ok, %ControllerServer{
            controller: Controller.new(BrewHouse.new),
            thermometer: {thermometer_mod, thermometer_mod.new},
            heater: {heater_mod, heater_mod.new}}}
  end

  @spec handle_cast(atom | {atom, any}, t) :: {:noreply, t}

  @doc "Start the controller."
  def handle_cast(:resume, %{controller: controller}=config) do
    {:noreply, %{config | controller: Controller.resume(controller)}}
  end

  @doc "Stop the controller."
  def handle_cast(:pause, %{controller: controller}=config) do
    {:noreply, %{config | controller: Controller.pause(controller)}}
  end

  def handle_cast({:mash_temp, new_temp}, %{controller: controller}=config) do
    {:noreply, %{config | controller: Controller.mash_temperature(controller, new_temp)}}
  end

  def handle_cast({:tick, now}, %{controller: controller,
                                  thermometer: {thermometer_mod, thermometer},
                                  heater: {heater_mod, heater}}=config) do

    new_temp = thermometer_mod.read(thermometer)
    controller = Controller.update(controller, now, new_temp)
    mode = Controller.mode?(controller)
    on_off = heater_mod.update(heater, mode)

    sample = %Sample{
      time: now,
      temperature: new_temp,
      heater: on_off,
      mode: mode,
      mash_temperature: Controller.mash_temperature?(controller)
    }

    Ctrl.TimeSeries.update sample.time |> DateTime.to_unix, sample

    {:noreply, %{config | controller: controller}}
  end

end
