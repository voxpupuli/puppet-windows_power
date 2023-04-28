# frozen_string_literal: true

require 'spec_helper'

describe 'windows_power::global::flags', type: :define do
  describe 'installing with invalid setting' do
    let(:title) { 'BatteryIcon' }
    let(:params) do
      { setting: 'xxx', status: 'on' }
    end

    it do
      expect do
        is_expected.to contain_exec('set globalpowerflag xxx')
      end.to raise_error(Puppet::Error, %r{The setting argument does not match a valid globalpower flag})
    end
  end

  describe 'installing with invalid status' do
    let(:title) { 'BatteryIcon' }
    let(:params) do
      { setting: 'BatteryIcon', status: 'xxx' }
    end

    it do
      expect do
        is_expected.to contain_exec('set globalpowerflag BatteryIcon')
      end.to raise_error(Puppet::Error, %r{The status argument is not valid for BatteryIcon})
    end
  end

  ['Windows XP', 'Windows Server 2003', 'Windows Server 2003 R2'].each do |os|
    describe 'installing setting BatteryIcon' do
      let(:title) { 'BatteryIcon' }
      let(:facts) do
        { operatingsystemversion: os }
      end
      let(:params) do
        { setting: 'BatteryIcon', status: 'on' }
      end

      it do
        is_expected.to contain_exec('set globalpowerflag BatteryIcon').with(
          'command' => 'C:\Windows\System32\powercfg.exe /globalpowerflag /option:BatteryIcon on'
        )
      end
    end
  end

  ['Windows Vista', 'Windows 7', 'Windows 8', 'Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012'].each do |os|
    describe 'installing setting BatteryIcon' do
      let(:title) { 'BatteryIcon' }
      let(:facts) do
        { operatingsystemversion: os }
      end
      let(:params) do
        { setting: 'BatteryIcon', status: 'on' }
      end

      it { is_expected.not_to contain_exec('set globalpowerflag BatteryIcon') }
    end
  end
end
