# frozen_string_literal: true

require 'spec_helper'

describe 'windows_power::devices::override', type: :define do
  ['Windows XP', 'Windows Server 2003', 'Windows Server 2003 R2'].each do |os|
    describe "requestsoverride not supported on #{os}" do
      let(:title) { 'wmplayer.exe' }
      let(:facts) do
        { operatingsystemversion: os }
      end
      let(:params) do
        { type: 'PROCESS', request: 'Display' }
      end

      it { is_expected.not_to contain_exec('request override for wmplayer.exe') }
    end
  end

  ['Windows Vista', 'Windows 7', 'Windows 8', 'Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012'].each do |os|
    describe "requestsoverride supported on #{os}" do
      let(:title) { 'wmplayer.exe' }
      let(:facts) do
        { operatingsystemversion: os }
      end
      let(:params) do
        { type: 'PROCESS', request: 'Display' }
      end

      it do
        is_expected.to contain_exec('request override for wmplayer.exe').with(
          'command' => 'C:\Windows\System32\powercfg.exe /requestsoverride PROCESS wmplayer.exe Display'
        )
      end
    end
  end

  describe 'requestsoverride of SERVICE' do
    let(:title) { 'MpsSvc' }
    let(:facts) do
      { operatingsystemversion: 'Windows 8' }
    end
    let(:params) do
      { type: 'SERVICE', request: 'System' }
    end

    it do
      is_expected.to contain_exec('request override for MpsSvc').with(
        'command' => 'C:\Windows\System32\powercfg.exe /requestsoverride SERVICE MpsSvc System'
      )
    end
  end
end
