require 'oystercard'

describe Oystercard do

  describe '#initialize' do
    it 'has a balance of zero' do
      expect(subject.balance).to eq(0)
    end
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1) }

    it 'updates the value of the balance' do
      subject.top_up(5)
      expect{ subject.top_up(5) }.to change{ subject.balance }.by 5
    end

    it 'raises an error if the maximum balance is exceeded' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up(maximum_balance)
      expect{ subject.top_up 1 }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
    end
  end

  describe '#touch_in' do
    it 'can touch in' do
      subject.top_up(20)
      subject.touch_in
      expect(subject).to be_in_journey
    end

    it 'raises an error when below minimum touch in balance' do
      expect{ subject.touch_in }.to raise_error "Below minimum touch in balance"
    end
  end

  describe '#touch_out' do
    it 'can touch out' do
      subject.top_up(20)
      subject.touch_in
      subject.touch_out
      expect(subject).not_to be_in_journey
    end

    it 'reduces the balance by minimum fare' do
      subject.top_up(20)
      subject.touch_in
      expect{ subject.touch_out }.to change {subject.balance }.by (-Oystercard::MINIMUM_BALANCE)
    end
    it 'raises an error if the maximum balance is exceeded' do
      expect{ subject.touch_out }.to raise_error "Not enough balance on card, please top up"
    end
  end

  describe '#in_journey?' do
    it 'returns the in_use state when not in use' do
      expect(subject).not_to be_in_journey
    end

    it 'returns the in_use state when in use' do
      subject.top_up(20)
      subject.touch_in
      expect(subject).to be_in_journey
    end
  end
end