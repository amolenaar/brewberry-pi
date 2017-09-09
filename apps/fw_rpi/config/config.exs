use Mix.Config

config :nerves, :firmware,
  fwup_conf: "config/rpi/fwup.conf",
  rootfs_overlay: "config/rootfs-additions"
