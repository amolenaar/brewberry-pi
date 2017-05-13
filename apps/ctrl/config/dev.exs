use Mix.Config

config :ctrl,
  measure_backend: Ctrl.Measure.FakeBackend,
  heater_backend: Ctrl.Heater.FakeBackend,
  thermometer: Ctrl.Thermometer.Fake,
  heater: Ctrl.Heater.Fake,
  brew_house: %{power: 2000, efficiency: 0.80, volume: 17, wait_time: 20}
