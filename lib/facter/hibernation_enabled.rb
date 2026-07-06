# frozen_string_literal: true

Facter.add(:hibernation_enabled) do
  confine kernel: 'windows'

  # This facts reads the registry value of
  # "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\HibernateEnabled"
  # to check if hibernation is active (1 = hibernation on, everything else = hibernation off)

  setcode do
    key = 'SYSTEM\\CurrentControlSet\\Control\\Power'
    value = nil
    Win32::Registry::HKEY_LOCAL_MACHINE.open(key, Win32::Registry::KEY_READ) do |reg|
      value = reg['HibernateEnabled']
    end
    value == 1
  rescue Win32::Registry::Error
    false
  end
end
