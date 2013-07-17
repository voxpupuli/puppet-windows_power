require 'spec_helper'

describe 'windows_power::global::hibernation', :type => :define do

  describe "updating with invalid status" do
    let :title do "hibernate on" end
    let :params do
      { :status => 'xxx' }
    end

    it do
      expect {
        should contain_exec('update hibernate status')
      }.to raise_error(Puppet::Error) {|e| expect(e.to_s).to match 'The status argument is not valid for hibernate'}
    end
  end

  describe "updating hibernate on" do
    let :title do "hibernate on" end
    let :params do
      { :status => "on" }
    end

    it { should contain_exec('update hibernate status').with(
      'command' => 'C:\\\\Windows\\\\System32\\\\powercfg.exe -hibernate on'
    ) }
  end

  describe "updating hibernate off" do
    let :title do "hibernate off" end
    let :params do
      { :status => "off" }
    end

    it { should contain_exec('update hibernate status').with(
      'command' => 'C:\\\\Windows\\\\System32\\\\powercfg.exe -hibernate off'
    ) }
  end
end