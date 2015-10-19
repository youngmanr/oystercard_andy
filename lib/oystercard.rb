class Oystercard
  MAXIMUM_BALANCE = 20

  attr_reader :balance

  def initialize(maximum_balance=MAXIMUM_BALANCE)
    @balance = 0
    @maximum_balance = maximum_balance
  end

  def top_up(value)
    fail "Maximum balance of #{@maximum_balance} exceeded" if value + balance > MAXIMUM_BALANCE
    @balance += value
  end
end