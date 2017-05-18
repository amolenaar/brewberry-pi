defmodule Ctrl.Thermometer do
  @moduledoc """
  Temperature sensor behaviour.
  """

  @opaque t :: %Ctrl.Thermometer{
    module: module,
    state: term
  }

  @type temp :: float | integer

  defstruct [:module, :state]

  @spec new(module) :: t
  def new(module) do
    {:ok, state} = module.init()
    %Ctrl.Thermometer{module: module, state: state}
  end

  @spec read(state :: term) :: temp
  def read(thermometer) do
    apply(thermometer.module, :handle_read, [thermometer.state])
  end

  @callback init() :: {:ok, term}
  @callback handle_read(state :: term) :: temp

end
