defmodule DisitributedBio.Modules.OpticalDensity.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      # Here's where we say that we wanna supervise optical density
      worker(DistributedBio.Modules.OpticalDensity, [DistributedBio.Modules.OpticalDensity])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
