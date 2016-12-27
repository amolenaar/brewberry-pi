# Brewberry &pi;

This repo contains the code of my brewberry-&pi; home brew software,
built with Elixir.

# Firmware

To build an image for the Raspberry Pi (model B):

  * Install dependencies with `mix deps.get`
  * Go to the firmware application with `cd apps/fw_rpi`
  * Copy `rootfs-additions/etc/wpa_supplicant.conf.example` to
    `rootfs-additions/etc/wpa_supplicant.conf` and fix the ssid and psk
     properties
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: http://www.nerves-project.org/
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
