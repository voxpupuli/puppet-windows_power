require 'spec_helper'

describe 'windows_power::devices::override', :type => :define do


  describe "installing with invalid type" do
    let :title do "wmplayer.exe" end
    let :params do
      { :type => 'xxx', :request => 'Display' }
    end

    it do
      expect {
        should contain_exec('request override for wmplayer.exe')
      }.to raise_error(Puppet::Error) {|e| expect(e.to_s).to match 'The caller type argument does not match: PROCESS, SERVICE or DRIVER'}
    end
  end

  describe "installing with invalid request" do
    let :title do "wmplayer.exe" end
    let :params do
      { :type => 'PROCESS', :request => 'xxx' }
    end

    it do
      expect {
        should contain_exec('request override for wmplayer.exe')
      }.to raise_error(Puppet::Error) {|e| expect(e.to_s).to match 'The request type argument does not match: Display, System or Awaymode'}
    end
  end

  ['Windows XP', 'Windows Server 2003', 'Windows Server 2003 R2'].each do |os|
    describe "requestsoverride not supported on #{os}" do
      let :title do "wmplayer.exe" end
      let :facts do
        { :operatingsystemversion => os }
      end
      let :params do
        { :type => 'PROCESS', :request => 'Display' }
      end

      it { should_not contain_exec('request override for wmplayer.exe') }
    end
  end

  ['Windows Vista', 'Windows 7', 'Windows 8', 'Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012'].each do |os|
    describe "requestsoverride supported on #{os}" do
      let :title do "wmplayer.exe" end
      let :facts do
        { :operatingsystemversion => os }
      end
      let :params do
        { :type => 'PROCESS', :request => 'Display' }
      end

      it { should contain_exec('request override for wmplayer.exe').with(
        'command' => 'C:\\\\Windows\\\\System32\\\\powercfg.exe /requestsoverride PROCESS wmplayer.exe Display'
      )}
    end
  end

  describe 'requestsoverride of SERVICE' do
    let :title do 'MpsSvc' end
    let :facts do
      { :operatingsystemversion => 'Windows 8' }
    end
    let :params do
      { :type => 'SERVICE', :request => 'System' }
    end

    it { should contain_exec('request override for MpsSvc').with(
      'command' => 'C:\\\\Windows\\\\System32\\\\powercfg.exe /requestsoverride SERVICE MpsSvc System'
    )}
  end
end