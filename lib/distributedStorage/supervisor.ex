defmodule DisitributedBio.DistributedStorage.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(DistributedBio.DistributedStorage.Registry.Supervisor, [DistributedBio.DistributedStorage.Registry.Supervisor]),
      worker(DistributedBio.CommandCenter.Supervisor, [DistributedBio.CommandCenter.Supervisor])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
