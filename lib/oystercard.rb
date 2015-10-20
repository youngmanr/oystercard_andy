class Oystercard
  MAXIMUM_BALANCE = 20
  MINIMUM_FARE = 1

  attr_reader :balance, :entry_station, :journeys

  def initialize
    @balance = 0
    @entry_station = nil
    @journeys = []
  end

  def top_up(value)
    fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if value + balance > MAXIMUM_BALANCE
    @balance += value
  end

  def touch_in(station)
    fail "Below minimum touch in balance" if @balance < MINIMUM_FARE
    @entry_station = Station.new(station)
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    @journeys << {:entry => @entry_station, :exit => Station.new(station)}
    @entry_station = nil
    station
  end

  def in_journey?
    !@entry_station.nil?
  end

  private
  def deduct(value)
    fail "Not enough balance on card, please top up" if balance - value < 0
    @balance -= value
  end
end
