# Brewberry &pi; [![Build Status](https://travis-ci.org/amolenaar/brewberry-pi.svg?branch=master)](https://travis-ci.org/amolenaar/brewberry-pi)


> Given a DS18B20 temperature sensor,
> a solid state relays and a wifi connector,
> automate the mash process.

At least, that's the plan.

This repo contains the code of my brewberry-&pi; home brew software,
built with [Elixir](http://elixir-lang.org) and [Nerves](http://nerves-project.org).

Brewberry &pi; can:

 * control temperature within a 0.1 &deg;C margin
 * read, set and control the mash process with your phone (web ui)
 * brewing software can be upgraded over the network
 * it's firmware, so you can pull out the plug at any time

Why Elixir/Nerves? Well...

 * Elixir is build on Erlang technology, making it fault tolerant by design.
 * Nerves provides a basis for *real* firmware. You can just pull out the power plug without bad things happening (you do not want to try that with Rasbian).
 * The system is up and running in less than 6 seconds(!) (not including wifi authentication). This is a lot faster than the 60 seconds it takes for Rasbian to boot.
 * The Erlang/Elixir actor model is a natural fit for message driven applications.

An older version of the Brewberry-&pi; written in Python is available at
https://github.com/amolenaar/brewberry-pi-python.

## Get started

 * run `mix deps.get`
 * `iex -S mix` will lauch the app and open a console, so you can tinker around
 * Open a browser on http://localhost:8080, the (web) app will be running there in "fake" mode
 
## Firmware

To build an image for the Raspberry Pi (model B):

  * Ensure Nerves stuff is installed on your machine, check out the Nerves getting started guide
  * Install dependencies with `MIX_ENV=prod mix deps.get`
  * Go to the firmware application with `cd apps/fw_rpi`
  * Copy `rootfs-additions/etc/wpa_supplicant.conf.example` to
    `rootfs-additions/etc/wpa_supplicant.conf` and fix the ssid and psk
     properties
  * Create firmware with `MIX_ENV=prod mix firmware`
  * Burn to an SD card with `MIX_ENV=prod mix firmware.burn`
  * And do remote updates once your first image is up and running: `MIX_ENV=prod mix firmware.push 10.192.168.122 --firmware ../../_build/rpi/prod/nerves/images/fw_rpi.fw`

## PCB

To control a brewing kettle some additional hardware is required:

 - http://learn.adafruit.com/adafruits-raspberry-pi-lesson-11-ds18b20-temperature-sensing
 - http://en.wikipedia.org/wiki/Solid-state\_relay

A schema is made with [Fritzing](http://fritzing.org) and is available in the file `Brouwerij.fzz`.

![schema](https://cdn.rawgit.com/amolenaar/brewberry-pi/master/Brouwerij_bb.svg)

### Bill of Materials

| Label | Part Type           | Properties                         |
| ----- | ------------------- | ---------------------------------- |
| -     | -                   | PCB prototype board                |
| J1    | Screw terminal      | 3 pins, connector to DS18B20       |
| J2    | Power plug          | connector to SSR                   |
| Pi1   | Adafruit Pi Cobbler | manufacturer Adafruit Industries   |
| Q1    | NPN-Transistor      | type NPN (EBC); package TO92 [THT] |
| R1    | 4.7kΩ Resistor      | pullup resistor                    |
| R2    | 1kΩ Resistor        |                                    |

## Learn more

  * Elixir: http://elixir-lang.com
  * Nerves docs: https://hexdocs.pm/nerves/getting-started.html
  * Nerves website: http://www.nerves-project.org/

## TODO

- [ ] Use bootloader from https://github.com/mobileoverlord/bootloader

