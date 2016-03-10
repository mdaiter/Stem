# DistributedAmino

#Stem.io

![alt tag](http://i.telegraph.co.uk/multimedia/archive/01893/stem_1893626b.jpg)

The beginnings of a distributed framework for Amino.bio firmware.

##Huh?

Amino.bio comes out soon, and synthetic biology will become more easily accessible for users to create 
and exchange biological programs between one another. Now that the hardware is available in our hands, 
wouldn't it be awesome if we were able to coordinate biological programs across platforms to coordinate 
distributed systems of cells to perform a certain task?

Hopefully, DistributedAmino solves this issue. With the advent of synthetic biology in consumer hands paired 
with the unique availability of genetic programming, we have an opportunity to make genetic programs coordinate 
across the internet with one another. Imagine if we were able to treat Amino kits as initial "stem cell" state 
modules, with each module sending other modules varying strengths of signals in order to modify its own state 
and behaviour. Coordinating cells to distribute tasks and function more like a body of cells split across sites 
could allow Amino users to create resilient, replicated, fault-tolerant tasks across multiple sites.

With this, we could create experiences not just dependent on one individual's imagination, but on the combined 
power and imagination of the community of Amino users.

We could create magic (trademark Disney).

##How it works
This demo involves two main source folders: one for modules, and one for networking. Each sensor and each event 
is registered as a single process. The system can run processes on other Aminos across the internet, and Aminos 
can monitor and respond to other Amino signals sent.

Each process has a supervisor attached to it, so if one process dies the supervisor will revive it with its current 
state. Each process runs independently with its own garbage collector, so if one process--whether it be a 
centrifuge driver or a network storage process--dies, it won't effect any other processes within the system. No 
single point of failure -> no interrupts in the development cycle.

Users can easily create processes inside of the Amino ecosystem. Each user-defined process is then launched into 
the system, where the process is run alongside all other tasks. Users can define add-on modules, their own 
programs to create applications, OR their own distributed tasks.

##Show me code

###Dependency requirements
How to install dependencies:

Linux firmware (currently supports Intel Galileo, RPi and Beaglebone Black, but is extendable to other platforms):
```
bake system get

bake toolchain get

bake firmware
```

Erlang/Elixir system:
```
mix deps.get

mix compile
```

Loading onto the board:
```
bake burn
```

This burns the firmware onto the board

###Starting the app

```
DistributedBio start
```

(This automatically starts the app)

###Module definition for addons
Let's say you want to define your own module on top of the Amino framework
```
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

```

This is a sample module that starts its own server, grabs sensor data and turns on a red LED when it grabs the data. 
You init the module by adding it to an array list of modules. Then, when the firmware is burned and loaded, you 
can access and play with your new module

###Storing data across Aminos
If you look at `lib/distributedStorage/registry`, you'll see a sample table definition for a database. The 
method for calling a read function on said database appears as such: 

```
use Amnesia

Amnesia.transaction do
	# To read by ID
	OpticalSensing.read(1)

	# Or, the less sadistic way: to read by constraint and grab a value from the structure (like a timestamp)
	selection = OpticalSensing.where value > 10,
		select: timestamp
end
```

And to write to the database:
```
use Amnesia


Amnesia.transaction do
	%OpticalSensing{timestamp: 12, status: "", value: 100} |> OpticalSensing.write
end
```

The database automatically distributes to other Amino kits, so each kit can keep track of its own and others' 
current data and state across machines. The amount of persistent connections equals the amount of total storage 
an Amino can carry.

##Future plans:
1. Launch tasks on another Amino (remote processes)
2. Store all info on blockchain to ensure non-corrupt data. Can we even have atomic rollbacks, where we reverse 
states of machines and states of cells at the same time? If so, can we experiment and machine learn how to 
solve some constraint-defined problem?
3. Constraint-defined programming. Too much imperativeness. What if we define programs for programming biology 
not in terms of a sequence of actions of which to operate, but by declaring constraints and properties of an outcome 
and letting the system figure out the most optimal way of solving a problem? Probably a heavily monadic, self-
correcting state machine.
