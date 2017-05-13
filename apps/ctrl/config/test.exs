use Mix.Config

config :ctrl,
  measure_backend: Ctrl.Measure.StaticBackend,
  heater_backend:  Ctrl.Heater.FakeBackend

