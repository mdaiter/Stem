defmodule DisitributedBio.DistributedStorage.Registry.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(DistributedBio.DistributedStorage.Registry, [DistributedBio.DistributedStorage.Registry])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
