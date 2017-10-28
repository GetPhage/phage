dev_null = Logger.new("/dev/null")
Rails.logger = dev_null
ActiveRecord::Base.logger = dev_null

namespace :flow do
  desc 'Identify flows'
  task :identify => [:environment] do
    dev_null = Logger.new("/dev/null")
    Rails.logger = dev_null
    ActiveRecord::Base.logger = dev_null

    Flow.identify
  end

  desc 'Associate flows with pcaps'
  task :mark_flows => [:environment] do
    dev_null = Logger.new("/dev/null")
    Rails.logger = dev_null
    ActiveRecord::Base.logger = dev_null

    Flow.mark_flows
  end

  desc 'Remove flow entries'
  task :clean => [:environment] do
    PartialFlow.update_all(flow_id: nil)
    Flow.delete_all
  end

  desc 'devices'
  task :device => [:environment] do
    Flow.all.each do |f|
      d = Device.where("'#{f.src_ip}' = ANY(ipv4) OR '#{f.dst_ip}' = ANY(ipv4)").first
      if d
        f.update_attributes(device: d)
      end
    end
  end

  desc 'hostnames'
  task :hostnames => [:environment] do
    ip_addresses = Flow.all.pluck(:dst_ip).uniq
    puts "Have #{ip_addresses.length} addresses"
    puts "Have #{Hostname.all.count} hostnames"
    ip_addresses.each do |ip|
      hostname = Hostname.find_by ipv4: ip.to_s
      next if hostname

      begin
        dns_result = Reversed.lookup(ip.to_s)
        if dns_result
          puts "#{ip} -> #{dns_result}"
          Hostname.create ipv4: ip, names: [ { hostname: dns_result, source: :dns, timestamp: Time.now } ]
        end
      rescue => error
        puts "error inverse resolving #{ip}"
        puts $!.message
        puts $!.backtrace
      end
    end
  end

  desc 'Mark old, incomplete partial flows'
  task :mark_old => [:environment] do
    most_recent_flow = Flow.order(timestamp: :desc).first
    PartialFlow.where("timestamp < ?", most_recent_flow.timestamp - 120.minutes).update(state: :ignored)
  end

  desc 'report'
  task :report => [:environment] do
    ActiveRecord::Base.logger.silence do
      Flow.all.each do |f|
        begin
          src_port = Socket.getservbyport(f.src_port)
        rescue
          src_port = f.src_port.to_s
        end

        begin
          dst_port = Socket.getservbyport(f.dst_port)
        rescue
          dst_port = f.dst_port.to_s
        end

        puts f.device.try(:friendly_name) || f.src_ip.to_s
        puts "#{f.src_ip.to_s}:#{src_port} -> #{f.dst_ip}:#{dst_port} #{f.bytes_sent} bytes in #{f.duration} seconds"
        puts
        puts
      end
    end
  end
end
