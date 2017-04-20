defmodule Brewberry.FwRpi do
  use Application

  alias Nerves.Networking

  @wlan_interface :wlan0
  @wpa_supplicant_conf "/etc/wpa_supplicant.conf"

  def start(_type, _args) do
    start_wifi()
    network_time()
    {:ok, self()}
  end

  def start_wifi do
    {_, 0} = System.cmd("/sbin/modprobe", ["8192cu"])

    System.cmd("/usr/sbin/wpa_supplicant", ["-s", "-B",
        "-i", @wlan_interface,
        "-D", "nl80211,wext",
        "-c", @wpa_supplicant_conf])
    :timer.sleep(500)

    Networking.setup @wlan_interface
  end

  def network_time do
    System.cmd("/usr/sbin/ntpd", ["-g"])
  end

  @dialyzer {:nowarn_function, start_wifi: 0}

end
