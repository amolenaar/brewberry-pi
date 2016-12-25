use Mix.Config

config :ctrl,
  measure_backend: Brewberry.Rpi.Backends.MeasureBackend,
  measure_backend: Brewberry.Rpi.Backends.HeaterBackend

