defmodule DisitributedBio.CommandCenter.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(DistributedBio.DistributedStorage.CommandCenter, [DistributedBio.DistributedStorage.CommandCenter])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
