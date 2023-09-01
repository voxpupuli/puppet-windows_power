# frozen_string_literal: true

require 'spec_helper'

describe 'windows_power::schemes::settings', type: :define do
  describe 'modifying setting disk-timeout-ac' do
    let(:title) { 'setting disk timeout (ac)' }
      let(:params) do
        { scheme_name: 'current_scheme', setting: 'disk-timeout-ac', value: 10 }
      end

    it do
      is_expected.to contain_exec('modify disk-timeout-ac setting for current_scheme').with(
        'provider' => 'powershell',
        'command' => '& powercfg /change disk-timeout-ac 10'
      )
    end

    it { is_expected.to compile }
  end
end
