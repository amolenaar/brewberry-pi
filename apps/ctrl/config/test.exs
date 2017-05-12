use Mix.Config

config :ctrl,
  measure_backend: Brewberry.Measure.StaticBackend,
  heater_backend:  Brewberry.Heater.FakeBackend

