use Mix.Config

config :ctrl,
  measure_backend: Ctrl.Measure.FakeBackend,
  heater_backend: Ctrl.Heater.FakeBackend
