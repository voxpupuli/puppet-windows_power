Facter.add(:power_devices, :type => :aggregate) do
  confine kernel: 'windows'

  chunk(:devices) do
    all_devices = Facter::Core::Execution.execute('powercfg /devicequery all_devices').split(/[\n\r]+/).reject{|x| x.eql?('')}
    wake_programmable = Facter::Core::Execution.execute('powercfg /devicequery wake_programmable').split(/[\n\r]+/).reject{|x| x.eql?('')}
    wake_armed = Facter::Core::Execution.execute('powercfg /devicequery wake_armed').split(/[\n\r]+/).reject{|x| x.eql?('')}
    wake_from_any = Facter::Core::Execution.execute('powercfg /devicequery wake_from_any').split(/[\n\r]+/).reject{|x| x.eql?('')}
    wake_from_s1_supported = Facter::Core::Execution.execute('powercfg /devicequery wake_from_s1_supported').split(/[\n\r]+/).reject{|x| x.eql?('')}
    wake_from_s2_supported = Facter::Core::Execution.execute('powercfg /devicequery wake_from_s2_supported').split(/[\n\r]+/).reject{|x| x.eql?('')}
    wake_from_s3_supported = Facter::Core::Execution.execute('powercfg /devicequery wake_from_s3_supported').split(/[\n\r]+/).reject{|x| x.eql?('')}
    s1_supported = Facter::Core::Execution.execute('powercfg /devicequery s1_supported').split(/[\n\r]+/).reject{|x| x.eql?('')}
    s2_supported = Facter::Core::Execution.execute('powercfg /devicequery s2_supported').split(/[\n\r]+/).reject{|x| x.eql?('')}
    s3_supported = Facter::Core::Execution.execute('powercfg /devicequery s3_supported').split(/[\n\r]+/).reject{|x| x.eql?('')}
    s4_supported = Facter::Core::Execution.execute('powercfg /devicequery s4_supported').split(/[\n\r]+/).reject{|x| x.eql?('')}

    devices = {}

    all_devices.each do |device|
      devices[device.to_sym] = {} unless devices.has_key?(device.to_sym)
      devices[device.to_sym].store(:wake_programmable, true) if wake_programmable.include?(device)
      devices[device.to_sym].store(:wake_armed, true) if wake_armed.include?(device)
      devices[device.to_sym].store(:wake_from_any, true) if wake_from_any.include?(device)
      devices[device.to_sym].store(:wake_from_s1_supported, true) if wake_from_s1_supported.include?(device)
      devices[device.to_sym].store(:wake_from_s2_supported, true) if wake_from_s2_supported.include?(device)
      devices[device.to_sym].store(:wake_from_s3_supported, true) if wake_from_s3_supported.include?(device)
      devices[device.to_sym].store(:s1_supported, true) if s1_supported.include?(device)
      devices[device.to_sym].store(:s2_supported, true) if s2_supported.include?(device)
      devices[device.to_sym].store(:s3_supported, true) if s3_supported.include?(device)
      devices[device.to_sym].store(:s4_supported, true) if s4_supported.include?(device)
    end

    devices.delete_if{|key, value| value.empty?}
    devices
  end

  chunk(:overrides) do
    overrides = Facter::Core::Execution.execute('powercfg /requestsoverride')

    devices = {}

    overrides.strip.each_line('') do |paragraph|
      caller_type = :unknown
      paragraph.strip.each_line(chomp: true) do |line|
        line.match(/^\[(.*)\]$/) do |match|
          caller_type = match[1].downcase.to_sym
          next
        end
        if caller_type != :unknown
          line.match(/^(.*?)((?:\s(DISPLAY|SYSTEM|AWAYMODE)(?!.*\b\3\b))+)$/) do |match|
            request = match[2].strip.split
            devices[match[1].to_sym] = {} unless devices.has_key?(match[1].to_sym)
            devices[match[1].to_sym][:power_request_overrides] = {} unless devices[match[1].to_sym].has_key?(:power_request_overrides)
            devices[match[1].to_sym][:power_request_overrides][caller_type] = {} unless devices[match[1].to_sym][:power_request_overrides].has_key?(caller_type)
            devices[match[1].to_sym][:power_request_overrides][caller_type].store(:display, true) if request.include?('DISPLAY')
            devices[match[1].to_sym][:power_request_overrides][caller_type].store(:system, true) if request.include?('SYSTEM')
            devices[match[1].to_sym][:power_request_overrides][caller_type].store(:awaymode, true) if request.include?('AWAYMODE')
          end
        end
      end
    end

    devices
  end
end
