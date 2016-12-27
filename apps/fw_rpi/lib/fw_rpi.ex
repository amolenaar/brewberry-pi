defmodule Rpi.FwRpi do
  use Application

  alias Nerves.Networking

  @lan_interface :eth0
  @wlan_interface :wlan0

  def start(_type, _args) do

    Task.start_link(fn -> Networking.setup @lan_interface end)
    Task.start_link(fn ->
      System.cmd("modprobe", ["8192uc"])
      System.cmd("/sbin/wpa_supplicant", ["-s", "-B",
          "-P", "/run/wpa_supplicant.wlan0.pid",
          "-i", @wlan_interface,
          "-D", "nl80211,wext",
          "-c", "/etc/wpa_supplicant/wpa_supplicant.conf"])
      Networking.setup @wlan_interface end)

    {:ok, self}
  end

end
