defmodule DisitributedBio.Modules.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      # As you add more modules onto the system, you can add them here
      worker(DistributedBio.Modules.CommandCenter, 
        [DistributedBio.Modules.CommandCenter])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
