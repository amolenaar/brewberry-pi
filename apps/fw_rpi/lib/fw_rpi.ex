defmodule Brewberry.FwRpi do
  use Application

  alias Nerves.Networking

  @lan_interface :eth0
  @wlan_interface :wlan0

  def start(_type, _args) do
#    System.cmd("modprobe", ["8192cu"])
#    :timer.sleep(250)
#    System.cmd("/usr/sbin/wpa_supplicant", ["-s", "-B",
#        "-i", @wlan_interface,
#        "-D", "wext",
#        "-c", "/etc/wpa_supplicant.conf"])
#    :timer.sleep(500)

#    Networking.setup @wlan_interface

    {:ok, self}
  end

end
