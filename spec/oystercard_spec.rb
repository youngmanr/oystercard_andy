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

  describe '#deduct' do
    it { is_expected.to respond_to(:deduct).with(1) }
    it 'deducts the amount from the existing balance' do
      subject.top_up(15)
      expect{subject.deduct(10) }.to change {subject.balance }.by -10
    end
    it 'raises an error if the maximum balance is exceeded' do
      expect{ subject.deduct 1 }.to raise_error "Not enough balance on card, please top up"
    end
  end

  describe '#touch_in' do
    it 'checks the return of value' do
      expect{ subject.touch_in }.to change{ subject.in_use }.from(false).to(true)
    end
  end

  describe '#touch_out' do
    it 'checks the return of value' do
      subject.touch_in
      expect{ subject.touch_out }.to change{ subject.in_use }.from(true).to(false)
    end
  end

  describe '#in_journey?' do
    it 'stores a state of the card' do
      expect(subject.in_journey?)a.to eq false
    end

    it 'stores a state of the card' do
      subject.touch_in
      expect(subject.in_journey?).to eq true
    end
  end
end