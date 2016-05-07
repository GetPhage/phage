require 'arp'
#require 'models'

class Scan
  class Passive
    def initialize
      @results = []
    
      lines = `/usr/sbin/arp -a`.split "\n"
      lines.each do |line|
        match = line.match /\((\d+\.\d+\.\d+\.\d+)\) at (\h{1,2}:\h{1,2}:\h{1,2}:\h{1,2}:\h{1,2}:\h{1,2})/
        next unless match

        @results.push({ ip: match[1], mac: match[2] })

#        @cache = Arp::Cache.new
      end
    end

    def results
#      @cache.each { |entry| yield entry }
      @results.each { |r| yield r }
    end

  def perform
#    scan = Scan.new scan_type: 'passive'
    results do |item|
#      ScanDiff.new(scan: scan,
                   
      d = Device.find_or_create_by!( mac_address: item[:mac]) do |device|
        device[:ipv4] = item[:ip]
      end
    end
  end
  end

end

