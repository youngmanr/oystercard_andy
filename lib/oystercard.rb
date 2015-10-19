class Oystercard
  MAXIMUM_BALANCE = 20
  MINIMUM_BALANCE = 1

  attr_reader :balance, :in_use

  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(value)
    fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if value + balance > MAXIMUM_BALANCE
    @balance += value
  end

  def touch_in
    fail "Below minimum touch in balance" if @balance < MINIMUM_BALANCE
    @in_use = true
  end

  def touch_out
    deduct(MINIMUM_BALANCE)
    @in_use = false
  end

  def in_journey?
    @in_use
  end

  private
  def deduct(value)
    fail "Not enough balance on card, please top up" if balance - value < 0
    @balance -= value
  end
end
