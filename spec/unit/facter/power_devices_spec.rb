# frozen_string_literal: true

require 'spec_helper'

describe 'power_devices fact' do
  after { Facter.clear }

  before { allow(Facter::Core::Execution).to receive(:execute).and_return('') }

  def stub_powercfg(outputs)
    outputs.each do |command, output|
      allow(Facter::Core::Execution).to receive(:execute).with(command).and_return(output)
    end
  end

  def power_devices(kernel: 'windows')
    Facter.clear
    Facter.add(:kernel, weight: 999) { setcode { kernel } }
    load File.expand_path('../../../lib/facter/power_devices.rb', __dir__)
    Facter.value(:power_devices)
  end

  let(:empty_queries) do
    {
      'powercfg /devicequery all_devices' => '',
      'powercfg /devicequery wake_programmable' => '',
      'powercfg /devicequery wake_armed' => '',
      'powercfg /devicequery wake_from_any' => '',
      'powercfg /devicequery wake_from_s1_supported' => '',
      'powercfg /devicequery wake_from_s2_supported' => '',
      'powercfg /devicequery wake_from_s3_supported' => '',
      'powercfg /devicequery s1_supported' => '',
      'powercfg /devicequery s2_supported' => '',
      'powercfg /devicequery s3_supported' => '',
      'powercfg /devicequery s4_supported' => '',
      'powercfg /requestsoverride' => '',
    }
  end

  it 'is unresolved off Windows' do
    expect(power_devices(kernel: 'linux')).to be_nil
  end

  context 'with device capabilities and request overrides' do
    before do
      stub_powercfg(
        empty_queries.merge(
          'powercfg /devicequery all_devices' => "HID-compliant mouse\nRealtek PCIe GbE Family Controller\nVolume\n",
          'powercfg /devicequery wake_programmable' => "HID-compliant mouse\nRealtek PCIe GbE Family Controller\n",
          'powercfg /devicequery wake_armed' => "HID-compliant mouse\nRealtek PCIe GbE Family Controller\n",
          'powercfg /devicequery wake_from_any' => "HID-compliant mouse\nRealtek PCIe GbE Family Controller\n",
          'powercfg /devicequery s1_supported' => "HID-compliant mouse\n",
          'powercfg /devicequery s3_supported' => "HID-compliant mouse\nRealtek PCIe GbE Family Controller\n",
          'powercfg /requestsoverride' => overrides,
        ),
      )
    end

    let(:overrides) do
      <<~OVERRIDES
        [PROCESS]
        wmplayer.exe DISPLAY AWAYMODE

        [DRIVER]
        Realtek PCIe GbE Family Controller DISPLAY SYSTEM
      OVERRIDES
    end

    it 'merges the device and override chunks into one structured hash' do
      expect(power_devices).to eq(
        {
          'HID-compliant mouse' => {
            'wake_programmable' => true,
            'wake_armed' => true,
            'wake_from_any' => true,
            's1_supported' => true,
            's3_supported' => true,
          },
          'Realtek PCIe GbE Family Controller' => {
            'wake_programmable' => true,
            'wake_armed' => true,
            'wake_from_any' => true,
            's3_supported' => true,
            'power_request_overrides' => {
              'driver' => { 'display' => true, 'system' => true },
            },
          },
          'wmplayer.exe' => {
            'power_request_overrides' => {
              'process' => { 'display' => true, 'awaymode' => true },
            },
          },
        },
      )
    end

    it 'drops devices that have neither capabilities nor overrides' do
      expect(power_devices).not_to have_key('Volume')
    end
  end

  context 'with no power devices at all' do
    before { stub_powercfg(empty_queries) }

    it 'is an empty hash' do
      expect(power_devices).to eq({})
    end
  end
end
