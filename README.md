# Brewberry &pi; [![Build Status](https://travis-ci.org/amolenaar/elixir-brewberry-pi.svg?branch=master)](https://travis-ci.org/amolenaar/elixir-brewberry-pi)

This repo contains the code of my brewberry-&pi; home brew software,
built with Elixir.

 * run `mix deps.get`
 * `iex -S mix` will lauch the app and open a console, so you can tinker around
 * Open a browser on http://localhost:8080, the (web) app will be running there in "fake" mode
 
# Firmware

To build an image for the Raspberry Pi (model B):

  * Ensure Nerves stuff is installed on your machine, check out the Nerves getting started guide
  * Install dependencies with `MIX_ENV=prod mix deps.get`
  * Go to the firmware application with `cd apps/fw_rpi`
  * Copy `rootfs-additions/etc/wpa_supplicant.conf.example` to
    `rootfs-additions/etc/wpa_supplicant.conf` and fix the ssid and psk
     properties
  * Create firmware with `MIX_ENV=prod mix firmware`
  * Burn to an SD card with `MIX_ENV=prod mix firmware.burn`
  * And do remote updates once your first image is up and running: `MIX_ENV=prod mix firmware.push 10.192.168.122 --firmware ../../_build/prod/nerves/images/fw_rpi.fw`

## Learn more

  * Elixir: http://elixir-lang.com
  * Nerves docs: https://hexdocs.pm/nerves/getting-started.html
  * Nerves website: http://www.nerves-project.org/

## TODO

- [ ] Use bootloader from https://github.com/mobileoverlord/bootloader

