defmodule Brewberry.Controller do
  @moduledoc """
  The controller used to keep my mash at a constant temperature.


              ,---------.
              v         |
             Idle ----->|
      :resume |         |
              v         |
        ,-> Resting --->|
        |     | dT>0.1  |
        |     v         |
        |   Heating --->|
        |     | dt=0    |
        |     v         |
        |   Slacking ---' :pause
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

   @doc "Start the controller."
    def handle_cast(:resume, {_on?, samples, config}) do
      {:noreply, {:on, samples, config}}
    end

   @doc "Stop the controller."
    def handle_cast(:pause, {_on?, samples, config}) do
      {:noreply, {:off, samples, config}}
    end

    @doc "Set heater mode to idle if the controller is off."
    def handle_call(%Sample{} = sample, _from, {:off = on?, samples, config}) do
      {:reply, %{sample | heater: :off, mode: :idle}, {on?, add_sample(sample, samples), config}}
    end

    @doc "handle temperature change when turned on."
    def handle_call(%Sample{} = sample, _from, {:on = on?, samples, config}) do
      mode = evaluate [sample | samples], config

      {:reply, %{sample | mode: mode}, {on?, add_sample(sample, samples), config}}
    end

    defp evaluate([%Sample{mode: :idle} | _samples], _config),
      do: :resting

    defp evaluate([%Sample{mode: :resting, temperature: temp, mash_temperature: mash_temp} | _samples], _config) when mash_temp - temp > 0.1,
      do: :heating

    defp evaluate([%Sample{mode: :resting} | _samples], _config),
      do: :resting

    defp evaluate([%Sample{mode: :heating, time: now, temperature: temp, mash_temperature: mash_temp} | _samples] = samples, config) do
      %{time: time} = lookup_sample samples, :heating
      dT = mash_temp - temp
      if dT <= 0 or now >= time + Config.time(config, dT) do
        :slacking
      else
        :heating
      end
    end

    defp evaluate([%Sample{mode: :slacking, time: now, temperature: temp} | _samples] = samples, config) do
      %{time: time} = lookup_sample samples, :slacking
      end_time = time + config.wait_time
      %{temperature: prev_temp} = (samples |> Enum.take(10) |> List.last)
      if now > end_time and \
        abs(prev_temp - temp) < 0.05 do
        :resting
      else
        :slacking
      end
    end

    defp add_sample(sample, samples),
      do: [ sample | samples ] |> Enum.take(4000)

    defp lookup_sample([head | []], _mode),
      do: head

    defp lookup_sample([%Sample{mode: mode} | tail], mode),
      do: lookup_sample(tail, mode)

    defp lookup_sample([head | _tail], _mode),
      do: head

  end
  ## Client interface

  @doc """
  Starts the registry.
  """
  def start_link(config \\ %Config{}, name \\ __MODULE__),
    do: GenServer.start_link(Server, config, [name: name])

  def resume(controller \\ __MODULE__),
    do: GenServer.cast(controller, :resume)

  def pause(controller \\ __MODULE__),
    do: GenServer.cast(controller, :pause)

  @doc """
  Ensures there is a bucket associated to the given `name` in `server`.
  """
  def update_sample(controller \\ __MODULE__, sample),
    do: GenServer.call(controller, sample)

end
