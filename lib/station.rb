class Station
  STATIONS = {"Old Street" => 1, "Bond Street" => 2, "Camden" => 3}

  attr_accessor :name, :zone

  def initialize(name)
    @name = name
    @zone = STATIONS[name]
  end

end

