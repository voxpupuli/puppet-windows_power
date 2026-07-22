# frozen_string_literal: true

require 'spec_helper'

describe 'hibernation_enabled fact' do
  after { Facter.clear }

  def hibernation_enabled(kernel: 'windows')
    Facter.clear
    Facter.add(:kernel, weight: 999) { setcode { kernel } }
    load File.expand_path('../../../lib/facter/hibernation_enabled.rb', __dir__)
    Facter.value(:hibernation_enabled)
  end

  def stub_registry(hklm)
    stub_const('Win32::Registry::Error', Class.new(StandardError))
    stub_const('Win32::Registry::KEY_READ', 0x20019)
    stub_const('Win32::Registry::HKEY_LOCAL_MACHINE', hklm)
  end

  def hklm_returning(value)
    double('HKEY_LOCAL_MACHINE').tap do |hklm| # rubocop:disable RSpec/VerifiedDoubles
      allow(hklm).to receive(:open).and_yield({ 'HibernateEnabled' => value })
    end
  end

  it 'is unresolved off Windows' do
    expect(hibernation_enabled(kernel: 'linux')).to be_nil
  end

  context 'when the registry key can be read' do
    it 'is true when HibernateEnabled is 1' do
      stub_registry(hklm_returning(1))
      expect(hibernation_enabled).to be(true)
    end

    it 'is false when HibernateEnabled is 0' do
      stub_registry(hklm_returning(0))
      expect(hibernation_enabled).to be(false)
    end

    it 'is false when HibernateEnabled holds any other value' do
      stub_registry(hklm_returning(2))
      expect(hibernation_enabled).to be(false)
    end
  end

  context 'when the registry key cannot be read' do
    it 'is false when opening the key raises a registry error' do
      hklm = double('HKEY_LOCAL_MACHINE') # rubocop:disable RSpec/VerifiedDoubles
      stub_registry(hklm)
      allow(hklm).to receive(:open).and_raise(Win32::Registry::Error)
      expect(hibernation_enabled).to be(false)
    end
  end
end
