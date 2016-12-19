defmodule Brewberry.Controller do
  @moduledoc """
  The controller used to keep my mash at a constant temperature.


              ,---------.
              v         |
            Idle ------>|
              | :start  |
              v         |
        ,-> Resting --->|
        |     | dT>0.1  |
        |     V         |
        |   Heating --->|
        |     | dt=0    |
        |     V         |
        |   Slacking ---' :stop
        |     | dT<0.05
        `-----'

  * `dT` is delta in temperature over a sliding window of _n_ samples
  * `dt` is the time the heater should be heating.
  """

  defmodule Config do
    @moduledoc """
    Configuration for the controller.
    * `power` in watts
    * `efficiency` is a factor
    * `volume` in litres
    * `wait_time` in seconds
    """

    defstruct power: 2000, efficiency: 0.80, volume: 17, wait_time: 20

    @doc """
    Calculate the time the heater should be turned on in order to
    reach the desired temperature.

    Returns the time in seconds the heater should be turned on.

    TODO: use time unit size native to Elixir
    """
    def time(config, dtemp) do
      joules_1_litre = 4186

      (dtemp * joules_1_litre * config.volume) / (config.power * config.efficiency)
      |> max(config.wait_time)
      |> round
    end
  end

  alias Brewberry.Sample


  defmodule Server do
    @moduledoc "The Controller process (callbacks)"
    use GenServer

    def init(config) do
      {:ok, {:off, [], config}}
    end

   @doc "Start the controller"
    def handle_cast(:resume, {_on?, samples, config}) do
      {:noreply, {:on, samples, config}}
    end

   @doc "Stop the controller"
    def handle_cast(:pause, {_on?, samples, config}) do
      {:noreply, {:off, samples, config}}
    end

    def handle_call(%Sample{} = sample, _from, {:off = on?, samples, config}) do
      {:reply, %{sample | heater: :off, mode: :idle}, {on?, add_sample(sample, samples), config}}
    end

    def handle_call(%Sample{} = sample, _from, {:on = on?, samples, config}) do
      mode = evaluate [sample | samples], config

      {:reply, %{sample | mode: mode}, {on?, add_sample(sample, samples), config}}
    end

    def evaluate([%Sample{mode: :idle} | _samples], _config) do
      :resting
    end

    def evaluate([%Sample{mode: :resting, temperature: temp, mash_temperature: mash_temp} | _samples], _config) do
      if mash_temp - temp > 0.1, do: :heating, else: :resting
    end

    def evaluate([%Sample{mode: :heating, time: now, mash_temperature: mash_temp} | _samples] = samples, config) do
      %{time: time, temperature: temp} = lookup_sample samples, :heating
      dT = mash_temp - temp
      if dT < 0 do
        :slacking
      else
        end_time = time + Config.time(config, dT)
        if now >= end_time do
          :slacking
        else
          :heating
        end
      end
    end

    def evaluate([%Sample{mode: :slacking, time: now, temperature: temp} | _samples] = samples, config) do
      %{time: time} = lookup_sample samples, :slacking
      end_time = time + config.wait_time
      %{temperature: prev_temp} = samples |> Enum.take(10) |> List.last
      if now > end_time and \
        abs(prev_temp - temp) < 0.05 do
        :resting
      else
        :slacking
      end
    end

    defp add_sample(sample, samples) do
      [ sample | samples ] |> Enum.take(4000)
    end

    defp lookup_sample([head | []], _mode) do
      head
    end

    defp lookup_sample([head | tail], required_mode) do
      %{mode: mode} = head
      if mode == required_mode, do: lookup_sample(tail, required_mode), else: head
    end

  end
  ## Client interface

  @doc """
  Starts the registry.
  """
  def start_link() do
    start_link(%Config{})
  end

  def start_link(config) do
    GenServer.start_link(Server, config, [name: __MODULE__])
  end

  def resume() do
    GenServer.cast(__MODULE__, :resume)
  end

  def pause() do
    GenServer.cast(__MODULE__, :pause)
  end

  @doc """
  Ensures there is a bucket associated to the given `name` in `server`.
  """
  def update_sample(sample) do
    GenServer.call(__MODULE__, sample)
  end

end
