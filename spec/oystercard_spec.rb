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






end