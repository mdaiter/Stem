defmodule DistributedBio do

  require Logger

  alias Nerves.IO.Ethernet
  require DisitributedBio.DistributedStorage.Supervisor
  require DisitributedBio.Modules.Supervisor

  use Application

  def start(_type, _args) do
    ## Need to start an internet connection
    {:ok, _} = Ethernet.setup :eth0
    {:ok, _} = DisitributedBio.Modules.Supervisor.start_link
    {:ok, _} = DisitributedBio.DistributedStorage.Supervisor.start_link
    {:ok, self}
  end

end
