dev_null = Logger.new("/dev/null")
Rails.logger = dev_null
ActiveRecord::Base.logger = dev_null

namespace :flow do
  desc 'Identify flows'
  task :identify => [:environment] do
      Flow.identify
  end

  desc 'Remove flow entries'
  task :clean => [:environment] do
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
