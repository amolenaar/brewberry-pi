use Mix.Config

import_config "#{Mix.env}.exs"

config :ctrl,
  brew_house: [power: 2000, efficiency: 0.80, volume: 17, wait_time: 20]
