defmodule DistributedBio.Modules.CommandCenter do
  use GenServer

  alias DistributedBio.DistributedStorage.Registry
  use Registry
  alias DistributedBio.DistributedStorage.Modules.OpticalDensity.Supervisor
  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def storeSensorData(server, data) do
    GenServer.call(server, {:store, data})
  end

  def lookupSensorData(server, id) do
    GenServer.call(server, {:lookup, id})
  end

  def init(:ok) do
    # Launch all sensors. Here's the list of sensors to start
    {:ok, _} = DistributedBio.DistributedStorage.Modules.OpticalDensity.Supervisor.start_link
    {:ok, opticalSensorPid} = DistributedBio.DistributedStorage.Modules.OpticalDensity.Supervisor.start_sensor()
    #If we got this far, return an :ok with the sensor PIDs
    {:ok, %{opticalSensorPid: opticalSensorPid}}
  end

  def handle_call({:store, data}, from, pids) do
    returnVal = Amnesia.transaction do
      # Data is expected to be formatted in the proper way when passed
      # to the function
      data |> Registry.write
    end
    {:reply, returnVal, pids}
  end

  def handle_call({:lookup, id}, from, pids) do
    returnVal = Amnesia.transaction do
      Registry.read(id)
    end
    {:reply, returnVal, pids}
  end

end
