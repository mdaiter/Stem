defmodule DistributedBio.Modules.OpticalDensity do
  use GenServer

  alias Nerves.IO.Led
  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def grabSensorData(server) do
    GenServer.call(server, {:grabSensorData})
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:grabSensorData}, _from, state) do
    # Let's pretend that the sensor data returns 100. I'll show you how to get an actual
    # sensor read later, but for now, pretend.
    sensorData = 100
    blink(:red)
    # Reply with our data. We don't ever really change our state, but state would be
    # used if we were modifying state
    {:reply, sensorData, state}
  end

  # Given an led key, flick it on for 100ms and then off.
  # Used for notifying a user when 
  defp blink(led_key) do
    Led.set [{led_key, true}]
    :timer.sleep 100
    Led.set [{led_key, false}]
  end

end
