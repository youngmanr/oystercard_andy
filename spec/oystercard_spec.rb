require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { double(:entry_station, name: "Old Street", zone: 1)}
  let(:exit_station) { double(:exit_station, name: "Oxford Street", zone: 2)}
  ENTRY_STATION = "Old Street"
  EXIT_STATION = "Camden"

  describe '#initialize' do
    it 'has a balance of zero' do
      expect(oystercard.balance).to eq(0)
    end

    it 'has an empty list of journeys' do
      expect(oystercard.journeys).to be_empty
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
      oystercard.touch_in(ENTRY_STATION)
      expect(oystercard).to be_in_journey
    end

    it 'raises an error when below minimum touch in balance' do
      expect{ oystercard.touch_in(entry_station) }.to raise_error "Below minimum touch in balance"
    end

    it 'updates the @entry_station on touch_in' do
      oystercard.top_up(20)
      oystercard.touch_in(ENTRY_STATION)
      expect(oystercard.entry_station.name).to eq "Old Street"
    end

  end

  describe '#touch_out' do
    it 'can touch out' do
      oystercard.top_up(20)
      oystercard.touch_in(ENTRY_STATION)
      oystercard.touch_out(ENTRY_STATION)
      expect(oystercard).not_to be_in_journey
    end
    it 'reduces the balance by minimum fare' do
      oystercard.top_up(20)
      oystercard.touch_in(ENTRY_STATION)
      expect{ oystercard.touch_out(EXIT_STATION) }.to change{ oystercard.balance }.by -Oystercard::MINIMUM_FARE
    end
    it 'raises an error if the maximum balance is exceeded' do
      expect{ oystercard.touch_out(EXIT_STATION) }.to raise_error "Not enough balance on card, please top up"
    end

    let(:journey) { {entry: entry_station, exit: exit_station} }
    it 'adds a journey to the journeys array' do
      oystercard.top_up(10)
      oystercard.touch_in(ENTRY_STATION)
      expect{oystercard.touch_out(EXIT_STATION)}.to change{ oystercard.journeys.length}.by 1
    end
  end

  describe '#in_journey?' do
    it 'returns the false when not in journey' do
      expect(oystercard).not_to be_in_journey
    end

    it 'returns the true state when in journey' do
      oystercard.top_up(20)
      oystercard.touch_in(ENTRY_STATION)
      expect(oystercard).to be_in_journey
    end

  end

end