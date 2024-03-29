# frozen_string_literal: true

require 'spec_helper'

describe 'windows_power::global::battery', type: :define do
  describe 'installing with invalid setting' do
    let(:title) { 'sound off' }
    let(:params) do
      { setting: 'xxx', status: 'on' }
    end

    it do
      expect do
        is_expected.to contain_exec('set batteryalarm xxx')
      end.to raise_error(Puppet::Error, %r{The setting argument does not match a valid batteryalarm setting})
    end
  end

  describe 'installing with invalid status' do
    let(:title) { 'sound off' }
    let(:params) do
      { setting: 'sound', status: 'xxx' }
    end

    it do
      expect do
        is_expected.to contain_exec('set batteryalarm sound')
      end.to raise_error(Puppet::Error, %r{The status argument is not valid for sound})
    end
  end

  ['Windows XP', 'Windows Server 2003', 'Windows Server 2003 R2'].each do |os|
    describe 'installing setting sound' do
      let(:title) { 'sound' }
      let(:facts) do
        { operatingsystemversion: os }
      end
      let(:params) do
        { setting: 'sound', status: 'on' }
      end

      it do
        is_expected.to contain_exec('set batteryalarm sound').with(
          'command' => 'C:\Windows\System32\powercfg.exe /batteryalarm LOW /sound on'
        )
      end
    end
  end

  ['Windows Vista', 'Windows 7', 'Windows 8', 'Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012'].each do |os|
    describe 'installing setting sound' do
      let(:title) { 'sound' }
      let(:facts) do
        { operatingsystemversion: os }
      end
      let(:params) do
        { setting: 'sound', status: 'on' }
      end

      it { is_expected.not_to contain_exec('set batteryalarm sound') }
    end
  end
end
