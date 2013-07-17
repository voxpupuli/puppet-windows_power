require 'spec_helper'

describe 'windows_power::devices::wake', :type => :define do


  describe 'enabling wake with invalid device' do
    let :title do 'network-device' end
    let :params do
      { :device => true, :ensure => 'enable' }
    end

    it do
      expect {
        should contain_exec('device network-device enable wake')
      }.to raise_error(Puppet::Error)
    end
  end

  describe 'enabling wake with invalid ensure' do
    let :title do 'network-device' end
    let :params do
      { :device => 'network-device', :ensure => 'x' }
    end

    it do
      expect {
        should contain_exec('device network-device enable wake')
      }.to raise_error(Puppet::Error) {|e| expect(e.to_s).to match 'The ensure argument does not match: enable or disable'}
    end
  end

  describe 'enabling wake' do
    let :title do 'VMBus Enumerator (001)' end
    let :params do
      { :device => 'VMBus Enumerator (001)', :ensure => 'enable' }
    end

    it { should contain_exec('device VMBus Enumerator (001) enable wake').with(
      'command' => 'C:\\\\Windows\\\\System32\\\\powercfg.exe /deviceenablewake "VMBus Enumerator (001)"'
    )}
  end

  describe 'disabling wake' do
    let :title do 'VMBus Enumerator (001)' end
    let :params do
      { :device => 'VMBus Enumerator (001)', :ensure => 'disable' }
    end

    it { should contain_exec('device VMBus Enumerator (001) disable wake').with(
      'command' => 'C:\\\\Windows\\\\System32\\\\powercfg.exe /devicedisablewake "VMBus Enumerator (001)"'
    )}
  end
end