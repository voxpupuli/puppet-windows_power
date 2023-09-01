# frozen_string_literal: true

require 'spec_helper'

describe 'windows_power::schemes::scheme', type: :define do
  describe 'creating inactive scheme' do
    let(:title) { 'inactive_scheme' }
      let(:params) do
        {
          scheme_name: 'inactive_scheme',
          scheme_guid: '381b4222-f694-41f0-9685-ff5bbxx65ddx',
          template_scheme: '381b4222-f694-41f0-9685-ff5bb260df2e',
          activation: 'inactive',
          ensure: 'present'
        }
      end

    it do
      is_expected.to contain_exec('create power scheme inactive_scheme').with(
        'provider' => 'powershell',
        'command' => '& powercfg /duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e 381b4222-f694-41f0-9685-ff5bbxx65ddx'
      )
    end

    it do
      is_expected.to contain_exec('rename scheme to inactive_scheme').with(
        'provider' => 'powershell',
        'command' => '& powercfg /changename 381b4222-f694-41f0-9685-ff5bbxx65ddx \'inactive_scheme\''
      )
    end

    it { is_expected.not_to contain_exec('set inactive_scheme scheme as active') }
    it { is_expected.not_to contain_exec('delete power scheme inactive_scheme') }
    it { is_expected.to compile }
  end

  describe 'creating and activating scheme' do
    let(:title) { 'active_scheme' }
      let(:params) do
        {
          scheme_name: 'active_scheme',
          scheme_guid: '381b4222-f694-41f0-9685-ff5bbxx65ddy',
          template_scheme: '381b4222-f694-41f0-9685-ff5bb260df2e',
          activation: 'active',
          ensure: 'present'
        }

    it do
      is_expected.to contain_exec('create power scheme active_scheme').with(
        'provider' => 'powershell',
        'command' => '& powercfg /duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e 381b4222-f694-41f0-9685-ff5bbxx65ddy'
      )
    end

    it do
      is_expected.to contain_exec('rename scheme to active_scheme').with(
        'provider' => 'powershell',
        'command' => '& powercfg /changename 381b4222-f694-41f0-9685-ff5bbxx65ddy \'active_scheme\''
      )
    end

    it do
      is_expected.to contain_exec('set active_scheme scheme as active').with(
        'provider' => 'powershell',
        'command' => '& powercfg /setactive 381b4222-f694-41f0-9685-ff5bbxx65ddy'
      )
    end

    it { is_expected.not_to contain_exec('delete power scheme active_scheme') }
    it { is_expected.to compile }
  end

  describe 'deleting scheme' do
    let(:title) { 'delete_scheme' }
      let(:params) do
        {
          scheme_name: 'delete_scheme',
          scheme_guid: '381b4222-f694-41f0-9685-ff5bbxx65ddz',
          template_scheme: '381b4222-f694-41f0-9685-ff5bb260df2e',
          activation: 'inactive',
          ensure: 'absent'
        }

    it do
      is_expected.to contain_exec('delete power scheme delete_scheme').with(
        'provider' => 'powershell',
        'command' => '& powercfg /delete 381b4222-f694-41f0-9685-ff5bbxx65ddz'
      )
    end

    it { is_expected.not_to contain_exec('create power scheme delete_scheme') }
    it { is_expected.not_to contain_exec('rename scheme to delete_scheme') }
    it { is_expected.not_to contain_exec('set delete_scheme scheme as active') }
    it { is_expected.to compile }
  end
end
