# frozen_string_literal: true

require 'spec_helper'

describe 'windows_power::scheme' do
  let(:facts) do
    {
      os: {
        windows: {
          system32: 'C:\WINDOWS\system32'
        }
      }
    }
  end

  context 'activate existing power scheme' do
    context 'which is not active yet' do
      let(:facts) do
        super().merge(
          {
            power_schemes: {
              '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c': {
                active: false
              }
            }
          }
        )
      end

      let(:params) do
        {
          guid: '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('windows_power::scheme') }

      it { is_expected.to contain_exec('activate_power_scheme').with_provider('windows') }

      it { is_expected.not_to contain_exec('duplicate_existing_power_scheme') }
      it { is_expected.not_to contain_exec('rename_power_scheme') }
    end

    context 'which is active already' do
      let(:facts) do
        super().merge(
          {
            power_schemes: {
              '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c': {
                active: true
              }
            }
          }
        )
      end

      let(:params) do
        {
          guid: '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('windows_power::scheme') }

      it { is_expected.not_to contain_exec('activate_power_scheme') }

      it { is_expected.not_to contain_exec('duplicate_existing_power_scheme') }
      it { is_expected.not_to contain_exec('rename_power_scheme') }
    end
  end

  context 'activate non-existing power scheme' do
    let(:facts) do
      super().merge(
        {
          power_schemes: {
            '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c': {}
          }
        }
      )
    end

    let(:params) do
      {
        guid: '3c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('windows_power::scheme') }

    it { is_expected.to contain_exec('activate_power_scheme').with_provider('powershell') }

    it { is_expected.not_to contain_exec('duplicate_existing_power_scheme') }
    it { is_expected.not_to contain_exec('rename_power_scheme') }
  end

  context 'rename existing power scheme' do
    context 'to new name' do
      let(:facts) do
        super().merge(
          {
            power_schemes: {
              '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c': {
                active: true,
                name: 'High performance'
              }
            }
          }
        )
      end

      let(:params) do
        {
          guid: '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c',
          label: 'super power'
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('windows_power::scheme') }

      it { is_expected.to contain_exec('rename_power_scheme') }

      it { is_expected.not_to contain_exec('activate_power_scheme') }
      it { is_expected.not_to contain_exec('duplicate_existing_power_scheme') }
    end

    context 'to matching name' do
      let(:facts) do
        super().merge(
          {
            power_schemes: {
              '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c': {
                active: true,
                name: 'super power'
              }
            }
          }
        )
      end

      let(:params) do
        {
          guid: '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c',
          label: 'super power'
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('windows_power::scheme') }

      it { is_expected.not_to contain_exec('rename_power_scheme') }

      it { is_expected.not_to contain_exec('activate_power_scheme') }
      it { is_expected.not_to contain_exec('duplicate_existing_power_scheme') }
    end
  end

  context 'duplicate existing power scheme' do
    context 'as new scheme' do
      let(:facts) do
        super().merge(
          {
            power_schemes: {
              '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c': {}
            }
          }
        )
      end

      let(:params) do
        {
          guid: '3c5e7fda-e8bf-4a96-9a85-a6e23a8c635c',
          template: '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('windows_power::scheme') }

      it { is_expected.to contain_exec('duplicate_existing_power_scheme') }

      it { is_expected.to contain_exec('activate_power_scheme').with_provider('powershell') }
      it { is_expected.not_to contain_exec('rename_power_scheme') }
    end

    context 'as existing scheme' do
      let(:facts) do
        super().merge(
          {
            power_schemes: {
              '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c': {},
              '3c5e7fda-e8bf-4a96-9a85-a6e23a8c635c': {
                active: true
              }
            }
          }
        )
      end

      let(:params) do
        {
          guid: '3c5e7fda-e8bf-4a96-9a85-a6e23a8c635c',
          template: '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('windows_power::scheme') }

      it { is_expected.not_to contain_exec('duplicate_existing_power_scheme') }

      it { is_expected.not_to contain_exec('activate_power_scheme') }
      it { is_expected.not_to contain_exec('rename_power_scheme') }
    end
  end

  context 'duplicate non-existing power scheme' do
    let(:facts) do
      super().merge(
        {
          power_schemes: {
            '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c': {}
          }
        }
      )
    end

    let(:params) do
      {
        guid: '3c5e7fda-e8bf-4a96-9a85-a6e23a8c635c',
        template: '7c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('windows_power::scheme') }

    it { is_expected.not_to contain_exec('duplicate_existing_power_scheme') }

    it { is_expected.to contain_exec('activate_power_scheme').with_provider('powershell') }
    it { is_expected.not_to contain_exec('rename_power_scheme') }
  end

  context 'configure existing power scheme' do
    context 'which is active already' do
      let(:facts) do
        super().merge(
          {
            power_schemes: {
              '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c': {
                active: true
              }
            }
          }
        )
      end

      let(:params) do
        {
          guid: '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c',
          settings: {
            'monitor-timeout-ac': 30,
            'monitor-timeout-dc': 10
          }
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('windows_power::scheme') }

      it { is_expected.to contain_exec('set_power_scheme_setting_monitor-timeout-ac') }
      it { is_expected.to contain_exec('set_power_scheme_setting_monitor-timeout-dc') }

      it { is_expected.not_to contain_exec('activate_power_scheme') }
      it { is_expected.not_to contain_exec('duplicate_existing_power_scheme') }
      it { is_expected.not_to contain_exec('rename_power_scheme') }
    end

    context 'which is not active yet' do
      let(:facts) do
        super().merge(
          {
            power_schemes: {
              '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c': {
                active: false
              }
            }
          }
        )
      end

      let(:params) do
        {
          guid: '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c',
          settings: {
            'monitor-timeout-ac': 30,
            'monitor-timeout-dc': 10
          }
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('windows_power::scheme') }

      it { is_expected.not_to contain_exec('set_power_scheme_setting_monitor-timeout-ac') }
      it { is_expected.not_to contain_exec('set_power_scheme_setting_monitor-timeout-dc') }

      it { is_expected.to contain_exec('activate_power_scheme').with_provider('windows') }
      it { is_expected.not_to contain_exec('duplicate_existing_power_scheme') }
      it { is_expected.not_to contain_exec('rename_power_scheme') }
    end
  end

  context 'configure non-existing power scheme' do
    let(:facts) do
      super().merge(
        {
          power_schemes: {
            '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c': {}
          }
        }
      )
    end

    let(:params) do
      {
        guid: '3c5e7fda-e8bf-4a96-9a85-a6e23a8c635c',
        settings: {
          'monitor-timeout-ac': 30,
          'monitor-timeout-dc': 10
        }
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('windows_power::scheme') }

    it { is_expected.not_to contain_exec('set_power_scheme_setting_monitor-timeout-ac') }
    it { is_expected.not_to contain_exec('set_power_scheme_setting_monitor-timeout-dc') }

    it { is_expected.to contain_exec('activate_power_scheme').with_provider('powershell') }
    it { is_expected.not_to contain_exec('duplicate_existing_power_scheme') }
    it { is_expected.not_to contain_exec('rename_power_scheme') }
  end
end
