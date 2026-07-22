# frozen_string_literal: true

require 'spec_helper'

describe 'power_settings fact' do
  after { Facter.clear }

  before { allow(Facter::Core::Execution).to receive(:execute).and_return('') }

  def power_settings(kernel: 'windows')
    Facter.clear
    Facter.add(:kernel, weight: 999) { setcode { kernel } }
    load File.expand_path('../../../lib/facter/power_settings.rb', __dir__)
    Facter.value(:power_settings)
  end

  it 'is unresolved off Windows' do
    expect(power_settings(kernel: 'linux')).to be_nil
  end

  context "with the active scheme's powercfg /query output" do
    before do
      allow(Facter::Core::Execution).to receive(:execute).with('powercfg /query').and_return(query)
    end

    let(:query) do
      <<~QUERY
        Power Scheme GUID: 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c  (High performance)
          GUID Alias: SCHEME_MIN
          Subgroup GUID: 0012ee47-9041-4b5d-9b77-535fba8b1442  (Hard disk)
            GUID Alias: SUB_DISK
            Power Setting GUID: 6738e2c4-e8a5-4a42-b16a-e040e769756e  (Turn off hard disk after)
              GUID Alias: DISKIDLE
              Minimum Possible Setting: 0x00000000
              Maximum Possible Setting: 0xffffffff
              Possible Settings increment: 0x00000001
              Possible Settings units: Seconds
            Current AC Power Setting Index: 0x00000000
            Current DC Power Setting Index: 0x000004b0

          Subgroup GUID: 7516b95f-f776-4464-8c53-06167f40cc99  (Display)
            GUID Alias: SUB_VIDEO
            Power Setting GUID: 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e  (Turn off display after)
              GUID Alias: VIDEOIDLE
              Minimum Possible Setting: 0x00000000
              Maximum Possible Setting: 0xffffffff
              Possible Settings increment: 0x00000001
              Possible Settings units: Seconds
            Current AC Power Setting Index: 0x00000708
            Current DC Power Setting Index: 0x00000258

          Subgroup GUID: 238c9fa8-0aad-41ed-83f4-97be242c8f20  (Sleep)
            GUID Alias: SUB_SLEEP
            Power Setting GUID: 29f6c1db-86da-48c5-9fdb-f2b67b1f44da  (Sleep after)
              GUID Alias: STANDBYIDLE
              Minimum Possible Setting: 0x00000000
              Maximum Possible Setting: 0xffffffff
              Possible Settings increment: 0x00000001
              Possible Settings units: Seconds
            Current AC Power Setting Index: 0x00000000
            Current DC Power Setting Index: 0x00000000

            Power Setting GUID: 9d7815a6-7ee4-497e-8888-515a05f02364  (Hibernate after)
              GUID Alias: HIBERNATEIDLE
              Minimum Possible Setting: 0x00000000
              Maximum Possible Setting: 0xffffffff
              Possible Settings increment: 0x00000001
              Possible Settings units: Seconds
            Current AC Power Setting Index: 0x00000000
            Current DC Power Setting Index: 0x00000000
      QUERY
    end

    it 'maps each subgroup to its AC/DC timeout in seconds' do
      expect(power_settings).to eq(
        {
          'monitor-timeout-ac' => 1800, 'monitor-timeout-dc' => 600,
          'disk-timeout-ac' => 0, 'disk-timeout-dc' => 1200,
          'standby-timeout-ac' => 0, 'standby-timeout-dc' => 0,
          'hibernate-timeout-ac' => 0, 'hibernate-timeout-dc' => 0,
        },
      )
    end
  end

  context 'with a subgroup missing from the output' do
    before do
      allow(Facter::Core::Execution).to receive(:execute).with('powercfg /query').and_return(query)
    end

    let(:query) do
      <<~QUERY
        Power Scheme GUID: 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c  (High performance)
          Subgroup GUID: 7516b95f-f776-4464-8c53-06167f40cc99  (Display)
            GUID Alias: SUB_VIDEO
            Power Setting GUID: 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e  (Turn off display after)
              GUID Alias: VIDEOIDLE
              Minimum Possible Setting: 0x00000000
              Maximum Possible Setting: 0xffffffff
              Possible Settings increment: 0x00000001
              Possible Settings units: Seconds
            Current AC Power Setting Index: 0x00000708
            Current DC Power Setting Index: 0x00000258
      QUERY
    end

    it 'defaults the absent subgroups to 0' do
      expect(power_settings).to eq(
        {
          'monitor-timeout-ac' => 1800, 'monitor-timeout-dc' => 600,
          'disk-timeout-ac' => 0, 'disk-timeout-dc' => 0,
          'standby-timeout-ac' => 0, 'standby-timeout-dc' => 0,
          'hibernate-timeout-ac' => 0, 'hibernate-timeout-dc' => 0,
        },
      )
    end
  end

  context 'when an index line carries no parseable value' do
    before do
      allow(Facter::Core::Execution).to receive(:execute).with('powercfg /query').and_return(query)
    end

    let(:query) do
      <<~QUERY
        Power Scheme GUID: 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c  (High performance)
          Subgroup GUID: 7516b95f-f776-4464-8c53-06167f40cc99  (Display)
            Power Setting GUID: 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e  (Turn off display after)
              Current AC Power Setting Index: 0x00000708
              Current DC Power Setting Index: 0x00000258

          Subgroup GUID: 0012ee47-9041-4b5d-9b77-535fba8b1442  (Hard disk)
            Power Setting GUID: 6738e2c4-e8a5-4a42-b16a-e040e769756e  (Turn off hard disk after)
              Possible Setting Index 000
              Possible Setting Index 001
      QUERY
    end

    it 'falls back to 0 without raising' do
      result = power_settings

      aggregate_failures do
        expect(result['monitor-timeout-ac']).to eq(1800)
        expect(result['disk-timeout-ac']).to eq(0)
        expect(result['disk-timeout-dc']).to eq(0)
      end
    end
  end
end
