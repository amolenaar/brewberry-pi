defmodule Brewberry.Rpi.Gpio do

  def output_pin(number) do
    if !File.exists?("/sys/class/gpio/gpio#{number}") do
      File.write! "/sys/class/gpio/export", "#{number}"
    end
    File.write! "/sys/class/gpio/gpio#{number}/direction", "out"
  end

  def read_pin(number) do
    File.read! "/sys/class/gpio/gpio#{number}/value"
  end

  def set_pin(number, :on) do
    File.write! "/sys/class/gpio/gpio#{number}/value", "1"
  end

  def set_pin(number, :off) do
    File.write! "/sys/class/gpio/gpio#{number}/value", "0"
  end

end
