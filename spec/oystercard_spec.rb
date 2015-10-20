require 'oystercard'

describe Oystercard do
subject(:oystercard) { described_class.new }

  describe '#initialize' do
    it 'has a balance of zero' do
      expect(oystercard.balance).to eq(0)
    end
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1) }

    it 'updates the value of the balance' do
      oystercard.top_up(5)
      expect{ oystercard.top_up(5) }.to change{ oystercard.balance }.by 5
    end

    it 'raises an error if the maximum balance is exceeded' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      oystercard.top_up(maximum_balance)
      expect{ oystercard.top_up 1 }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
    end
  end

  describe '#touch_in' do
    it 'can touch in' do
      oystercard.top_up(20)
      oystercard.touch_in
      expect(oystercard).to be_in_journey
    end

    it 'raises an error when below minimum touch in balance' do
      expect{ oystercard.touch_in }.to raise_error "Below minimum touch in balance"
    end
  end

  describe '#touch_out' do
    it 'can touch out' do
      oystercard.top_up(20)
      oystercard.touch_in
      oystercard.touch_out
      expect(oystercard).not_to be_in_journey
    end

    it 'reduces the balance by minimum fare' do
      oystercard.top_up(20)
      oystercard.touch_in
      expect{ oystercard.touch_out }.to change{ oystercard.balance }.by -Oystercard::MINIMUM_FARE
    end
    it 'raises an error if the maximum balance is exceeded' do
      expect{ oystercard.touch_out }.to raise_error "Not enough balance on card, please top up"
    end
  end

  describe '#in_journey?' do
    it 'returns the in_use state when not in use' do
      expect(oystercard).not_to be_in_journey
    end

    it 'returns the in_use state when in use' do
      oystercard.top_up(20)
      oystercard.touch_in
      expect(oystercard).to be_in_journey
    end
  end
end