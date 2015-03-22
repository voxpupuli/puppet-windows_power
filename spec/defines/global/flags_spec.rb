require 'spec_helper'

describe 'windows_power::global::flags', :type => :define do

  describe "installing with invalid setting" do
    let :title do "BatteryIcon" end
    let :params do
      { :setting => 'xxx', :status => 'on' }
    end

    it do
      expect {
        should contain_exec('set globalpowerflag xxx')
      }.to raise_error(Puppet::Error) {|e| expect(e.to_s).to match 'The setting argument does not match a valid globalpower flag'}
    end
  end

  describe "installing with invalid status" do
    let :title do "BatteryIcon" end
    let :params do
      { :setting => 'BatteryIcon', :status => 'xxx' }
    end

    it do
      expect {
        should contain_exec('set globalpowerflag BatteryIcon')
      }.to raise_error(Puppet::Error) {|e| expect(e.to_s).to match 'The status argument is not valid for BatteryIcon'}
    end
  end

  ['Windows XP', 'Windows Server 2003', 'Windows Server 2003 R2'].each do |os|
    describe "installing setting BatteryIcon" do
      let :title do "BatteryIcon" end
      let :facts do
        { :operatingsystemversion => os }
      end
      let :params do
        { :setting => "BatteryIcon", :status => "on" }
      end

      it { should contain_exec("set globalpowerflag BatteryIcon").with(
        'command' => 'C:\Windows\System32\powercfg.exe /globalpowerflag /option:BatteryIcon on'
      ) }
    end
  end

  ['Windows Vista', 'Windows 7', 'Windows 8', 'Windows Server 2008', 'Windows Server 2008 R2','Windows Server 2012'].each do |os|
    describe "installing setting BatteryIcon" do
      let :title do "BatteryIcon" end
      let :facts do
        { :operatingsystemversion => os }
      end
      let :params do
        { :setting => "BatteryIcon", :status => "on" }
      end

      it { should_not contain_exec("set globalpowerflag BatteryIcon") }
    end
  end
end