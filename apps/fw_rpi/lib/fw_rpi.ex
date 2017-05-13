defmodule FwRpi do
  use Application

  alias Nerves.Networking

  @wlan_interface :wlan0
  @wpa_supplicant_conf "/etc/wpa_supplicant.conf"

  def start(_type, _args) do
    start_wifi()
    start_network()
    network_time()
    {:ok, self()}
  end

  @spec start_wifi() :: :ok
  def start_wifi do
    {_, 0} = System.cmd("/sbin/modprobe", ["8192cu"])

    {_, 0} = System.cmd("/usr/sbin/wpa_supplicant", ["-s", "-B",
        "-i", Atom.to_string(@wlan_interface),
        "-D", "nl80211,wext",
        "-c", @wpa_supplicant_conf])
    :timer.sleep(500)
    :ok
  end

  @spec start_network() :: :ok
  def start_network do
    {:ok, _} = Networking.setup @wlan_interface
    :ok
  end

  def network_time do
    {_, 0} = System.cmd("/usr/sbin/ntpd", ["-g"])
    :ok
  end

#  @dialyzer {:nowarn_function, start_network: 0}
#  @dialyzer {:nowarn_function, start: 2}
end
