# frozen_string_literal: true

require 'spec_helper'

describe 'windows_power::devices::wake', type: :define do
  describe 'enabling wake' do
    let(:title) { 'VMBus Enumerator (001)' }
    let(:params) do
      { device: 'VMBus Enumerator (001)', ensure: 'enable' }
    end

    it do
      is_expected.to contain_exec('device VMBus Enumerator (001) enable wake').with(
        'provider' => 'windows',
        'command' => 'powercfg /deviceenablewake "VMBus Enumerator (001)"'
      )
    end

    it { is_expected.to compile }
  end

  describe 'disabling wake' do
    let(:title) { 'VMBus Enumerator (001)' }
    let(:params) do
      { device: 'VMBus Enumerator (001)', ensure: 'disable' }
    end

    it do
      is_expected.to contain_exec('device VMBus Enumerator (001) disable wake').with(
        'provider' => 'windows',
        'command' => 'powercfg /devicedisablewake "VMBus Enumerator (001)"'
      )
    end

    it { is_expected.to compile }
  end
end
