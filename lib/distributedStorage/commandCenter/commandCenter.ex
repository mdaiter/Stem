defmodule DistributedBio.DistributedStorage.CommandCenter do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def grabSensorData(server, sensor, name) do
    GenServer.call(server, {:callSensor, sensor, name})
  end

  def init(:ok) do
    {:ok}
  end

  def handle_call({:callSensor, sensor, name}, _from, state) do
    Node.spawn_link name, fn ->

    end
    {:reply, {}, state}
  end
end
