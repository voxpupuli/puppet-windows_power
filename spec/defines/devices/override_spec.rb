# frozen_string_literal: true

require 'spec_helper'

describe 'windows_power::devices::override', type: :define do
  describe 'requestsoverride of PROCESS' do
    let(:title) { 'wmplayer.exe' }
    let(:params) do
      { type: 'PROCESS', request: 'Display' }
    end

    it do
      is_expected.to contain_exec('request override for wmplayer.exe').with(
        'provider' => 'windows',
        'command' => 'powercfg /requestsoverride PROCESS wmplayer.exe Display'
      )
    end

    it { is_expected.to compile }
  end

  describe 'requestsoverride of SERVICE' do
    let(:title) { 'MpsSvc' }
    let(:params) do
      { type: 'SERVICE', request: 'System' }
    end

    it do
      is_expected.to contain_exec('request override for MpsSvc').with(
        'provider' => 'windows',
        'command' => 'powercfg /requestsoverride SERVICE MpsSvc System'
      )
    end

    it { is_expected.to compile }
  end
end
