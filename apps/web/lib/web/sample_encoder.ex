defimpl Poison.Encoder, for: Ctrl.Sample do
  @moduledoc false

  alias Ctrl.Sample

  def encode(sample = %Sample{time: time, heater: heater}, options) do
    Poison.Encoder.Map.encode(%{sample |> Map.from_struct |
      time: time |> DateTime.from_unix! |> DateTime.to_naive |> NaiveDateTime.to_iso8601,
      heater: heater == :on}, options)
  end

end
