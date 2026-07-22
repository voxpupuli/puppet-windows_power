# frozen_string_literal: true

require 'spec_helper'

describe 'power_schemes fact' do
  after { Facter.clear }

  before { allow(Facter::Core::Execution).to receive(:execute).and_return('') }

  def power_schemes(kernel: 'windows')
    Facter.clear
    Facter.add(:kernel, weight: 999) { setcode { kernel } }
    load File.expand_path('../../../lib/facter/power_schemes.rb', __dir__)
    Facter.value(:power_schemes)
  end

  it 'is unresolved off Windows' do
    expect(power_schemes(kernel: 'linux')).to be_nil
  end

  context 'with a typical listing' do
    before do
      allow(Facter::Core::Execution).to receive(:execute).with('powercfg /l').and_return(listing)
    end

    let(:listing) do
      <<~SCHEMES
        Existing Power Schemes (* Active)
        -----------------------------------
        Power Scheme GUID: 381b4222-f694-41f0-9685-ff5bb260df2e  (Balanced)
        Power Scheme GUID: 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c  (High performance) *
        Power Scheme GUID: a1841308-3541-4fab-bc81-f71556f20b4a  (Power saver)
      SCHEMES
    end

    it 'maps each scheme GUID to its name and active state' do
      expect(power_schemes).to eq(
        {
          '381b4222-f694-41f0-9685-ff5bb260df2e' => { 'name' => 'Balanced', 'active' => false },
          '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c' => { 'name' => 'High performance', 'active' => true },
          'a1841308-3541-4fab-bc81-f71556f20b4a' => { 'name' => 'Power saver', 'active' => false },
        },
      )
    end

    it 'marks only the scheme ending in "*" as active' do
      active = power_schemes.select { |_guid, data| data['active'] }
      expect(active.keys).to eq(['8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'])
    end

    it 'ignores the header and separator lines' do
      expect(power_schemes.size).to eq(3)
    end
  end

  context 'with no schemes listed' do
    before do
      allow(Facter::Core::Execution).to receive(:execute).with('powercfg /l').and_return('')
    end

    it 'is an empty hash' do
      expect(power_schemes).to eq({})
    end
  end
end
