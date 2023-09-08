Facter.add(:power_schemes) do
  confine kernel: 'windows'

  setcode do
    schemes = Facter::Core::Execution.execute('powercfg /l')

    power_schemes = {}

    schemes.strip.each_line(chomp: true) do |line|
      line.match(/^.*?([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*\((.*)\).*$/) do |match|
        power_schemes[match[1].to_sym] = {
          name: match[2],
          active: line.end_with?('*')
        }
      end
    end

    power_schemes
  end
end
