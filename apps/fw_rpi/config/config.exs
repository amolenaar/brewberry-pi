use Mix.Config

config :nerves, :firmware,
  fwup_conf: "config/rpi/fwup.conf",
  rootfs_additions: "config/rootfs-additions"
# if unset, the default regulatory domain is the world domain, "00"
config :nerves_interim_wifi,
  regulatory_domain: "NL"
