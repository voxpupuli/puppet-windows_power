# frozen_string_literal: true

require 'spec_helper'

describe 'windows_power' do
  let(:facts) do
    {
      os: {
        windows: {
          system32: 'C:\WINDOWS\system32'
        }
      }
    }
  end

  context 'with default configuration' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('windows_power') }
  end

  context 'with example configuration' do
    let(:params) do
      {
        devices: {
          'HID-compliant mouse (001)': {
            enable_wake: true
          },
          'wmplayer.exe': {
            power_request_overrides: {
              process: {
                display: true,
                awaymode: true
              }
            }
          },
          'Realtek PCIe GbE Family Controller': {
            enable_wake: false,
            power_request_overrides: {
              driver: {
                display: true,
                system: true
              }
            }
          }
        }
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('windows_power') }

    it { is_expected.to contain_windows_power__device('HID-compliant mouse (001)') }
    it { is_expected.to contain_windows_power__device('wmplayer.exe') }
    it { is_expected.to contain_windows_power__device('Realtek PCIe GbE Family Controller') }
  end
end
