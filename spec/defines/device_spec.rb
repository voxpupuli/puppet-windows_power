# frozen_string_literal: true

require 'spec_helper'

describe 'windows_power::device' do
  let(:facts) do
    {
      os: {
        windows: {
          system32: 'C:\WINDOWS\system32'
        }
      }
    }
  end

  context 'let your mouse wake the system' do
    let(:title) { 'HID-compliant mouse (001)' }

    let(:params) do
      {
        enable_wake: true
      }
    end

    context 'if it doesn\'t already' do
      let(:facts) do
        super().merge(
          {
            power_devices: {
              'HID-compliant mouse (001)': {
                wake_programmable: true,
                wake_armed: false
              }
            }
          }
        )
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_windows_power__device('HID-compliant mouse (001)') }

      it { is_expected.to contain_exec('enable_device_wake_HID-compliant mouse (001)') }
      it { is_expected.not_to contain_exec('disable_device_wake_HID-compliant mouse (001)') }
    end

    context 'if it does already' do
      let(:facts) do
        super().merge(
          {
            power_devices: {
              'HID-compliant mouse (001)': {
                wake_programmable: true,
                wake_armed: true
              }
            }
          }
        )
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_windows_power__device('HID-compliant mouse (001)') }

      it { is_expected.not_to contain_exec('enable_device_wake_HID-compliant mouse (001)') }
      it { is_expected.not_to contain_exec('disable_device_wake_HID-compliant mouse (001)') }
    end

    context 'if it doesn\'t exist' do
      let(:facts) do
        super().merge(
          {
            power_devices: {}
          }
        )
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_windows_power__device('HID-compliant mouse (001)') }

      it { is_expected.not_to contain_exec('enable_device_wake_HID-compliant mouse (001)') }
      it { is_expected.not_to contain_exec('disable_device_wake_HID-compliant mouse (001)') }
    end

    context 'if it doesn\'t allow to' do
      let(:facts) do
        super().merge(
          {
            power_devices: {
              'HID-compliant mouse (001)': {
                wake_programmable: false
              }
            }
          }
        )
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_windows_power__device('HID-compliant mouse (001)') }

      it { is_expected.not_to contain_exec('enable_device_wake_HID-compliant mouse (001)') }
      it { is_expected.not_to contain_exec('disable_device_wake_HID-compliant mouse (001)') }
    end
  end

  context 'don\'t let your mouse wake the system' do
    let(:title) { 'HID-compliant mouse (001)' }

    let(:params) do
      {
        enable_wake: false
      }
    end

    context 'if it does' do
      let(:facts) do
        super().merge(
          {
            power_devices: {
              'HID-compliant mouse (001)': {
                wake_programmable: true,
                wake_armed: true
              }
            }
          }
        )
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_windows_power__device('HID-compliant mouse (001)') }

      it { is_expected.to contain_exec('disable_device_wake_HID-compliant mouse (001)') }
      it { is_expected.not_to contain_exec('enable_device_wake_HID-compliant mouse (001)') }
    end

    context 'if it doesn\'t' do
      let(:facts) do
        super().merge(
          {
            power_devices: {
              'HID-compliant mouse (001)': {
                wake_programmable: true,
                wake_armed: false
              }
            }
          }
        )
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_windows_power__device('HID-compliant mouse (001)') }

      it { is_expected.not_to contain_exec('disable_device_wake_HID-compliant mouse (001)') }
      it { is_expected.not_to contain_exec('enable_device_wake_HID-compliant mouse (001)') }
    end
  end

  context 'if device is not in facts' do
    let(:facts) do
      super().merge(
        {
          power_devices: {}
        }
      )
    end

    context 'don\'t allow Windows media player to keep system from turning off the display or from going to away mode' do
      let(:title) { 'wmplayer.exe' }

      let(:params) do
        {
          power_request_overrides: {
            process: {
              display: true,
              awaymode: true
            }
          }
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_windows_power__device('wmplayer.exe') }

      it { is_expected.to contain_exec('set_power_request_override_process_wmplayer.exe') }
      it { is_expected.not_to contain_exec('set_power_request_override_service_wmplayer.exe') }
      it { is_expected.not_to contain_exec('set_power_request_override_driver_wmplayer.exe') }
    end

    context 'don\'t allow your network card to keep your display turned on or keep the system active' do
      let(:title) { 'Realtek PCIe GbE Family Controller' }

      let(:params) do
        {
          power_request_overrides: {
            driver: {
              display: true,
              system: true
            }
          }
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_windows_power__device('Realtek PCIe GbE Family Controller') }

      it { is_expected.to contain_exec('set_power_request_override_driver_Realtek PCIe GbE Family Controller') }
      it { is_expected.not_to contain_exec('set_power_request_override_service_Realtek PCIe GbE Family Controller') }
      it { is_expected.not_to contain_exec('set_power_request_override_process_Realtek PCIe GbE Family Controller') }
    end
  end

  context 'if device is in facts' do
    context 'if current state is desired state' do
      let(:title) { 'Realtek PCIe GbE Family Controller' }

      let(:facts) do
        super().merge(
          {
            power_devices: {
              'Realtek PCIe GbE Family Controller': {
                power_request_overrides: {
                  driver: {
                    display: true,
                    system: true
                  }
                }
              }
            }
          }
        )
      end

      let(:params) do
        {
          power_request_overrides: {
            driver: {
              display: true,
              system: true
            }
          }
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_windows_power__device('Realtek PCIe GbE Family Controller') }

      it { is_expected.not_to contain_exec('set_power_request_override_service_Realtek PCIe GbE Family Controller') }
      it { is_expected.not_to contain_exec('set_power_request_override_process_Realtek PCIe GbE Family Controller') }
      it { is_expected.not_to contain_exec('set_power_request_override_driver_Realtek PCIe GbE Family Controller') }
      it { is_expected.not_to contain_exec('remove_power_request_override_service_Realtek PCIe GbE Family Controller') }
      it { is_expected.not_to contain_exec('remove_power_request_override_process_Realtek PCIe GbE Family Controller') }
      it { is_expected.not_to contain_exec('remove_power_request_override_driver_Realtek PCIe GbE Family Controller') }
    end

    context 'if current state is not desired state' do
      context 'overwrite existing overrides' do
        let(:title) { 'Realtek PCIe GbE Family Controller' }

        let(:facts) do
          super().merge(
            {
              power_devices: {
                'Realtek PCIe GbE Family Controller': {
                  power_request_overrides: {
                    driver: {
                      system: true,
                      awaymode: true
                    }
                  }
                }
              }
            }
          )
        end

        let(:params) do
          {
            power_request_overrides: {
              driver: {
                display: true,
                system: true
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_windows_power__device('Realtek PCIe GbE Family Controller') }

        it { is_expected.to contain_exec('set_power_request_override_driver_Realtek PCIe GbE Family Controller') }
        it { is_expected.not_to contain_exec('set_power_request_override_service_Realtek PCIe GbE Family Controller') }
        it { is_expected.not_to contain_exec('set_power_request_override_process_Realtek PCIe GbE Family Controller') }
        it { is_expected.not_to contain_exec('remove_power_request_override_service_Realtek PCIe GbE Family Controller') }
        it { is_expected.not_to contain_exec('remove_power_request_override_process_Realtek PCIe GbE Family Controller') }
        it { is_expected.not_to contain_exec('remove_power_request_override_driver_Realtek PCIe GbE Family Controller') }
      end

      context 'remove existing overrides' do
        let(:title) { 'VPN Service' }

        let(:facts) do
          super().merge(
            {
              power_devices: {
                'VPN Service': {
                  power_request_overrides: {
                    service: {
                      system: true
                    }
                  }
                }
              }
            }
          )
        end

        let(:params) do
          {
            power_request_overrides: {
              service: {
                system: false
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_windows_power__device('VPN Service') }

        it { is_expected.to contain_exec('remove_power_request_override_service_VPN Service') }
        it { is_expected.not_to contain_exec('remove_power_request_override_process_VPN Service') }
        it { is_expected.not_to contain_exec('remove_power_request_override_driver_VPN Service') }
        it { is_expected.not_to contain_exec('set_power_request_override_service_VPN Service') }
        it { is_expected.not_to contain_exec('set_power_request_override_process_VPN Service') }
        it { is_expected.not_to contain_exec('set_power_request_override_driver_VPN Service') }
      end
    end
  end
end
