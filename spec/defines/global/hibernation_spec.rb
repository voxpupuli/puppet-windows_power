require 'spec_helper'

describe 'windows_power::global::hibernation', type: :define do
  describe 'updating with invalid status' do
    let(:title) { 'hibernate on' }
    let(:params) do
      { status: 'xxx' }
    end

    it do
      expect do
        should contain_exec('update hibernate status')
      end.to raise_error(Puppet::Error, %r{The status argument is not valid for hibernate})
    end
  end

  describe 'updating hibernate on' do
    let(:title) { 'hibernate on' }
    let(:params) do
      { status: 'on' }
    end

    it do
      should contain_exec('update hibernate status').with(
        'command' => 'C:\Windows\System32\powercfg.exe -hibernate on'
      )
    end
  end

  describe 'updating hibernate off' do
    let(:title) { 'hibernate off' }
    let(:params) do
      { status: 'off' }
    end

    it do
      should contain_exec('update hibernate status').with(
        'command' => 'C:\Windows\System32\powercfg.exe -hibernate off'
      )
    end
  end
end
