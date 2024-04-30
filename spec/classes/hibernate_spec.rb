require 'spec_helper'

describe 'windows_power::hibernate' do
  let(:facts) do
    {
      os: {
        windows: {
          system32: 'C:\WINDOWS\system32'
        }
      }
    }
  end

  context 'disable hibernation system wide' do
    let(:params) do
      {
        enable: false
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('windows_power::hibernate') }

    it { is_expected.to contain_exec('disable_hibernate') }
  end

  context 'enable hibernation with default settings' do
    let(:params) do
      {
        enable: true
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('windows_power::hibernate') }

    it { is_expected.to contain_exec('enable_hibernate') }
    it { is_expected.not_to contain_exec('set_hiberfile_size') }
    it { is_expected.not_to contain_exec('set_hiberfile_type') }
  end

  context 'enable and configure hibernation' do
    let(:params) do
      {
        enable: true,
        hiberfile_size: 100,
        hiberfile_type: 'full'
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('windows_power::hibernate') }

    it { is_expected.to contain_exec('enable_hibernate') }
    it { is_expected.to contain_exec('set_hiberfile_size').with_command('powercfg /hibernate /size 100') }
    it { is_expected.to contain_exec('set_hiberfile_type').with_command('powercfg /hibernate /type full') }
  end
end
