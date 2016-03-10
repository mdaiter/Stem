require Amnesia
use Amnesia

defdatabase DistributedBio.DistributedStorage.Registry do
  deftable OpticalSensing, [:timestamp, :status, :value], type: :ordered_set do
    # Add more types here if you want to store them!
    @type t :: %OpticalSensing {
      timestamp: non_neg_integer,
      status: String.t,
      value: non_neg_integer
    }
  end
end
