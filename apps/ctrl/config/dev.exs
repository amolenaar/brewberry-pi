use Mix.Config

config :ctrl,
  measure_backend: Brewberry.Measure.FakeBackend,
  heater_backend: Brewberry.Heater.FakeBackend
