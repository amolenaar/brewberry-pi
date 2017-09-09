use Mix.Config

config :nerves, :firmware,
  fwup_conf: "config/rpi/fwup.conf",
  rootfs_overlay: "config/rootfs-additions"

config :nerves_network,
  regulatory_domain: "NL"

import_config "wifi.exs"
