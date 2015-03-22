require 'spec_helper'

describe 'windows_power::schemes::settings', :type => :define do

  describe "installing with invalid scheme name" do
    let :title do "set disk timeout" end
    let :params do
      { :setting => 'disk-timeout-ac', :scheme_name => true, :value => '0' }
    end

    it do
      expect {
        should contain_exec('modify xxx setting for test')
      }.to raise_error(Puppet::Error)
    end
  end

  describe "installing with invalid setting" do
    let :title do "set disk timeout" end
    let :params do
      { :setting => 'xxx', :scheme_name => 'test', :value => '0' }
    end

    it do
      expect {
        should contain_exec('modify xxx setting for test')
      }.to raise_error(Puppet::Error) {|e| expect(e.to_s).to match 'The setting argument does not match a valid scheme setting'}
    end
  end

  describe "installing with invalid value" do
    let :title do "set disk timeout" end
    let :params do
      { :setting => 'disk-timeout-ac', :scheme_name => 'test', :value => 'xx' }
    end

    it do
      expect {
        should contain_exec('modify disk-timeout-ac setting for test')
      }.to raise_error(Puppet::Error) {|e| expect(e.to_s).to match 'The value provided is not appropriate for the disk-timeout-ac setting' }
    end
  end

  describe "installing with disk-timeout-ac to 10 mins" do
    let :title do "set disk timeout" end
    let :params do
      { :setting => 'disk-timeout-ac', :scheme_name => 'test', :value => '10' }
    end

    it { should contain_exec('modify disk-timeout-ac setting for test').with(
      'provider' => 'powershell',
      'command' => '& C:\Windows\System32\powercfg.exe /change disk-timeout-ac 10'
    )}
  end

end