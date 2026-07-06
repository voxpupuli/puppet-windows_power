# frozen_string_literal: true

# rubocop:disable Style/RegexpLiteral

Facter.add(:power_settings) do
  confine kernel: 'windows'

  # This fact runs "powercfg /query" to get the settings
  # for the currently active power scheme.

  setcode do
    output = Facter::Core::Execution.execute('powercfg /query')
    data_blocks = output.split(/\n\n/)

    result = {
      'monitor-timeout-ac'    => 0,
      'monitor-timeout-dc'    => 0,
      'disk-timeout-ac'       => 0,
      'disk-timeout-dc'       => 0,
      'standby-timeout-ac'    => 0,
      'standby-timeout-dc'    => 0,
      'hibernate-timeout-ac'  => 0,
      'hibernate-timeout-dc'  => 0,
    }

    hex = '[a-f0-9]'
    guid_re = "#{hex}{8}-#{hex}{4}-#{hex}{4}-#{hex}{4}-#{hex}{12}"

    # Split the output of "powercfg /query" into blocks (empty line = new block begins):
    data_blocks.each do |block|
      guid = ''
      lines = block.lines(chomp: true)
      lines.each do |line|
        if line.match /(#{guid_re})/
          # Get the last GUID in the block
          guid = $1
        end
      end
      # Get the hex values of the last two lines in a block.
      # Example output:
      # Index der aktuellen Wechselstromeinstellung: 0x00000002
      # Index der aktuellen Gleichstromeinstellung: 0x00000002
      ac = lines[-2].split(': ')[1].to_i(0) # AC in seconds
      dc = lines[-1].split(': ')[1].to_i(0) # DC in seconds

      # "powercfg /aliases" displays a list of aliases and their corresponding GUIDs:
      # 0012ee47-9041-4b5d-9b77-535fba8b1442  SUB_DISK
      # 6738e2c4-e8a5-4a42-b16a-e040e769756e    DISKIDLE      -> disk-timeout-ac/-dc
      # 238c9fa8-0aad-41ed-83f4-97be242c8f20  SUB_SLEEP
      # 9d7815a6-7ee4-497e-8888-515a05f02364    HIBERNATEIDLE -> hibernate-timeout-ac/-dc
      # 29f6c1db-86da-48c5-9fdb-f2b67b1f44da    STANDBYIDLE   -> standby-timeout-ac/-dc
      # 7516b95f-f776-4464-8c53-06167f40cc99  SUB_VIDEO
      # 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e    VIDEOIDLE     -> monitor-timeout-ac/-dc
      case guid
      when '3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e' # VIDEOIDLE
        result['monitor-timeout-ac'] = ac
        result['monitor-timeout-dc'] = dc
      when '6738e2c4-e8a5-4a42-b16a-e040e769756e' # DISKIDLE
        result['disk-timeout-ac'] = ac
        result['disk-timeout-dc'] = dc
      when '29f6c1db-86da-48c5-9fdb-f2b67b1f44da' # STANDBYIDLE
        result['standby-timeout-ac'] = ac
        result['standby-timeout-dc'] = dc
      when '9d7815a6-7ee4-497e-8888-515a05f02364' # HIBERNATEIDLE
        result['hibernate-timeout-ac'] = ac
        result['hibernate-timeout-dc'] = dc
      end
    end
    result
  end
end

# rubocop:enable Style/RegexpLiteral
