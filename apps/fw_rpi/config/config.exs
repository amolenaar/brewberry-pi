use Mix.Config

config :nerves, :firmware,
  fwup_conf: "config/rpi/fwup.conf",
  rootfs_additions: "config/rootfs-additions"
