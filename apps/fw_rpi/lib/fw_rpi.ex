defmodule Brewberry.FwRpi do
  use Application

  alias Nerves.Networking

  @wlan_interface :wlan0

  def start(_type, _args) do
    if File.exists?("/etc/wpa_supplicant.conf") do
      start_wifi()
      network_time()
    end
    {:ok, self()}
  end

  def start_wifi do
    System.cmd("/sbin/modprobe", ["8192cu"])
    :timer.sleep(250)

    System.cmd("/usr/sbin/wpa_supplicant", ["-s", "-B",
        "-i", @wlan_interface,
        "-D", "nl80211,wext",
        "-c", "/etc/wpa_supplicant.conf"])
    :timer.sleep(500)

    Networking.setup @wlan_interface
  end

  def network_time do
    System.cmd("/usr/sbin/ntpd", ["-g"])
  end

  @dialyzer {:nowarn_function, start_wifi: 0}

end
