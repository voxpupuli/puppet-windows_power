require 'spec_helper'

describe 'windows_power::schemes::scheme', :type => :define do

  describe "installing with invalid scheme name" do
    let :title do "create new scheme test" end
    let :params do
      { :scheme_name => true, :scheme_guid => '381b4222-f694-41f0-9685-ff5bb260df2e' }
    end

    it do
      expect {
        should contain_exec('create power scheme test')
      }.to raise_error(Puppet::Error)
    end
  end

  describe "installing with invalid scheme guid" do
    let :title do "create new scheme test" end
    let :params do
      { :scheme_name => 'test', :scheme_guid => 'x' }
    end

    it do
      expect {
        should contain_exec('create power scheme test')
      }.to raise_error(Puppet::Error) {|e| expect(e.to_s).to match 'The scheme guid provided is not formatted correctly' }
    end
  end

  describe "installing with invalid ensure" do
    let :title do "create new scheme test" end
    let :params do
      { :scheme_name => 'test', :scheme_guid => '381b4222-f694-41f0-9685-ff5bb260df2e', :ensure => 'fubar' }
    end

    it do
      expect {
        should contain_exec('create power scheme test')
      }.to raise_error(Puppet::Error) {|e| expect(e.to_s).to match 'The ensure argument is not set to present or absent'}
    end
  end

  ['Windows Vista','Windows 7','Windows 8','Windows Server 2008','Windows Server 2008 R2','Windows Server 2012'].each do |os|
    describe "installing with invalid template scheme name" do
      let :title do "create new scheme test" end
      let :facts do
        { :operatingsystemversion => os }
      end
      let :params do
        { :scheme_name => true, :scheme_guid => '381b4222-f694-41f0-9685-ff5bb260df2e', :template_scheme => true }
      end

      it do
        expect {
          should contain_exec('create power scheme test')
        }.to raise_error(Puppet::Error)
      end
    end

    describe "installing with invalid activation" do
      let :title do "create new scheme test" end
      let :facts do
        { :operatingsystemversion => os }
      end
      let :params do
        { :scheme_name => 'test', :scheme_guid => '381b4222-f694-41f0-9685-ff5bb260df2e', :activation => 'fubar' }
      end

      it do
        expect {
          should contain_exec('create power scheme test')
        }.to raise_error(Puppet::Error) {|e| expect(e.to_s).to match 'The activation argument is not set to active or inactive'}
      end
    end
  end

  ['Windows XP', 'Windows Server 2003', 'Windows Server 2003 R2'].each do |os|
    describe "create scheme on #{os}" do
      let :title do "create new scheme test" end
      let :facts do
        { :operatingsystemversion => os }
      end
      let :params do
        { :scheme_name => 'test', :scheme_guid => '381b4222-f694-41f0-9685-ff5bb260df2f', :ensure => 'present' }
      end

      it { should contain_exec('create power scheme test').with(
        'provider' => 'powershell',
        'command' => '& C:\\\\Windows\\\\System32\\\\powercfg.exe /create test'
      )}
    end
  end

  ['Windows Vista','Windows 7','Windows 8','Windows Server 2008','Windows Server 2008 R2','Windows Server 2012'].each do |os|
    describe "create and activate scheme on #{os}" do
      let :title do "create new scheme test" end
      let :facts do
        { :operatingsystemversion => os }
      end
      let :params do
        { :scheme_name => 'test', :scheme_guid => '381b4222-f694-41f0-9685-ff5bb260df2f',
          :template_scheme => '381b4222-f694-41f0-9685-ff5bb260df2e', :ensure => 'present', :activation => 'active' }
      end

      it { should contain_exec('create power scheme test').with(
        'provider' => 'powershell',
        'command' => '& C:\\\\Windows\\\\System32\\\\powercfg.exe -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e 381b4222-f694-41f0-9685-ff5bb260df2f'
      )}

      it { should contain_exec('rename scheme to test').with(
        'provider' => 'powershell',
        'command' => '& C:\\\\Windows\\\\System32\\\\powercfg.exe -changename 381b4222-f694-41f0-9685-ff5bb260df2f test'
      )}

      it { should contain_exec('set test scheme as active').with(
        'provider' => 'powershell',
        'command' => '& C:\\\\Windows\\\\System32\\\\powercfg.exe -setactive 381b4222-f694-41f0-9685-ff5bb260df2f'
      ) }
    end

    describe "create and inactive scheme on #{os}" do
      let :title do "create new scheme test" end
      let :facts do
        { :operatingsystemversion => os }
      end
      let :params do
        { :scheme_name => 'test', :scheme_guid => '381b4222-f694-41f0-9685-ff5bb260df2f',
          :template_scheme => '381b4222-f694-41f0-9685-ff5bb260df2e', :ensure => 'present', :activation => 'inactive' }
      end

      it { should contain_exec('create power scheme test').with(
        'provider' => 'powershell',
        'command' => '& C:\\\\Windows\\\\System32\\\\powercfg.exe -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e 381b4222-f694-41f0-9685-ff5bb260df2f'
      )}

      it { should contain_exec('rename scheme to test').with(
        'provider' => 'powershell',
        'command' => '& C:\\\\Windows\\\\System32\\\\powercfg.exe -changename 381b4222-f694-41f0-9685-ff5bb260df2f test'
      )}

      it { should_not contain_exec('set test scheme as active') }
    end
  end

  describe "delete scheme" do
    let :title do "delete scheme scheme test" end
    let :params do
      { :scheme_name => 'test', :scheme_guid => '381b4222-f694-41f0-9685-ff5bb260df2f', :ensure => 'absent' }
    end

    it { should contain_exec('delete power scheme test').with(
      'provider' => 'powershell',
      'command' => '& C:\\\\Windows\\\\System32\\\\powercfg.exe -delete 381b4222-f694-41f0-9685-ff5bb260df2f'
    )}
  end
end