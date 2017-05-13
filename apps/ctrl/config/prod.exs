use Mix.Config

config :ctrl,
  measure_backend: Ctrl.Rpi.Backends.MeasureBackend,
  heater_backend:  Ctrl.Rpi.Backends.HeaterBackend

