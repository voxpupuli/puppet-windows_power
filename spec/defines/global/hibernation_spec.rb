# frozen_string_literal: true

require 'spec_helper'

describe 'windows_power::global::hibernation', type: :define do
  describe 'updating hibernate on' do
    let(:title) { 'hibernate on' }
    let(:params) do
      { status: 'on' }
    end

    it do
      is_expected.to contain_exec('update hibernate status').with(
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
      is_expected.to contain_exec('update hibernate status').with(
        'command' => 'C:\Windows\System32\powercfg.exe -hibernate off'
      )
    end
  end
end
