require 'spec_helper'

describe 'windows_power::global::battery', :type => :define do

  describe "installing with invalid setting" do
    let :title do "sound off" end
    let :params do
      { :setting => 'xxx', :status => 'on' }
    end

    it do
      expect {
        should contain_exec('set batteryalarm xxx')
      }.to raise_error(Puppet::Error) {|e| expect(e.to_s).to match 'The setting argument does not match a valid batteryalarm setting'}
    end
  end

  describe "installing with invalid status" do
    let :title do "sound off" end
    let :params do
      { :setting => 'sound', :status => 'xxx' }
    end

    it do
      expect {
        should contain_exec('set batteryalarm sound')
      }.to raise_error(Puppet::Error) {|e| expect(e.to_s).to match 'The status argument is not valid for sound'}
    end
  end

  describe "installing with invalid criticality" do
    let :title do "sound off" end
    let :params do
      { :setting => 'sound', :status => 'on', :criticality => 'xxx' }
    end

    it do
      expect {
        should contain_exec('set batteryalarm sound')
      }.to raise_error(Puppet::Error) {|e| expect(e.to_s).to match 'The status argument does not match: LOW or HIGH'}
    end
  end

  ['Windows XP', 'Windows Server 2003', 'Windows Server 2003 R2'].each do |os|
    describe "installing setting sound" do
      let :title do "sound" end
      let :facts do
        { :operatingsystemversion => os }
      end
      let :params do
        { :setting => "sound", :status => "on" }
      end

      it { should contain_exec("set batteryalarm sound").with(
        'command' => 'C:\Windows\System32\powercfg.exe /batteryalarm LOW /sound on'
      ) }
    end
  end

  ['Windows Vista', 'Windows 7', 'Windows 8', 'Windows Server 2008', 'Windows Server 2008 R2','Windows Server 2012'].each do |os|
    describe "installing setting sound" do
      let :title do "sound" end
      let :facts do
        { :operatingsystemversion => os }
      end
      let :params do
        { :setting => "sound", :status => "on" }
      end

      it { should_not contain_exec("set batteryalarm sound") }
    end
  end
end