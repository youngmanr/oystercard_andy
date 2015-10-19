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
      expect{subject.top_up(5)}.to change{ subject.balance }.by 5
    end
  end


end