use Mix.Config

config :nerves, :firmware,
  fwup_conf: "config/rpi/fwup.conf",
  rootfs_overlay: "config/rootfs-additions"

config :nerves_network,
  regulatory_domain: "NL"

config :shoehorn,
  overlay_path: "/tmp/erl_shoehorn",
  init: [:nerves_runtime], # Init network, with fw_rpi
  app: :fw_rpi # Load :web app instead?

import_config "wifi.exs"
