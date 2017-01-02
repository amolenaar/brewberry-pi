# Brewberry &pi; [![Build Status](https://travis-ci.org/amolenaar/elixir-brewberry-pi.svg?branch=master)](https://travis-ci.org/amolenaar/elixir-brewberry-pi)

This repo contains the code of my brewberry-&pi; home brew software,
built with Elixir.

 * run `mix deps.get`
 * `iex -S mix` will lauch the app and open a console, so you can tinker around
 * Open a browser on http://localhost:8080, the (web) app will be running there in "fake" mode
 
# Firmware

To build an image for the Raspberry Pi (model B):

  * Ensure Nerves stuff is installed on your machine, check out the Nerves getting started guide
  * Install dependencies with `mix deps.get`
  * Go to the firmware application with `cd apps/fw_rpi`
  * Copy `rootfs-additions/etc/wpa_supplicant.conf.example` to
    `rootfs-additions/etc/wpa_supplicant.conf` and fix the ssid and psk
     properties
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`


## Learn more

  * Elixir: http://elixir-lang.com
  * Nerves docs: https://hexdocs.pm/nerves/getting-started.html
  * Nerves website: http://www.nerves-project.org/
