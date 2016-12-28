use Mix.Config

config :ctrl,
  measure_backend: Brewberry.Rpi.Backends.MeasureBackend,
  heater_backend:  Brewberry.Rpi.Backends.HeaterBackend

