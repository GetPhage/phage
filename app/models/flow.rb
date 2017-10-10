class Flow < ApplicationRecord
  belongs_to :device

  def country
    puts dst_ip.to_s
    geo_ip = GeoIp.where("ipaddr >>= inet ?", dst_ip.to_s).first
    geo_ip.try(:geo_location)
  end

  def self.identify
    ActiveRecord::Base.logger.silence do
      puts "Got so many", PartialFlow.where(is_fin: true).count

      PartialFlow.where(is_fin: true).each do |fin_pkt|
#        byebug

        # only consider fin from the remote host
        next unless self.is_local?(fin_pkt.dst_ip)

        syn_pkt = self.find_syn_pkt fin_pkt
        puts "syn_pkt fail" unless syn_pkt
        next unless syn_pkt

        dst_syn_pkt = self.find_dst_syn_pkt fin_pkt
        puts "dst_syn_pkt fail" unless dst_syn_pkt
        next unless dst_syn_pkt

        puts "already_processed fail" if self.is_already_processed? syn_pkt
        next if self.is_already_processed? syn_pkt

        d = Device.where("? = ANY(ipv4)", syn_pkt.src_ip.to_s).first || Device.where("? = ANY(ipv4)", syn_pkt.dst_ip.to_s).first
        unless d
          d = Device.create mac_address: fin_pkt.mac_address,
                            ipv4: [ syn_pkt.src_ip ],
                            kind: '',
                            last_seen: Time.now
        end

        # we sub 2 from the bytes sent to account for SYN and FIN
        bytes_sent = fin_pkt.src_ack - syn_pkt.src_seq - 2
        bytes_received = fin_pkt.src_seq - dst_syn_pkt.src_seq - 2

        flow = Flow.create src_ip: syn_pkt.src_ip,
                           dst_ip: syn_pkt.dst_ip,
                           src_port: syn_pkt.src_port,
                           dst_port: syn_pkt.dst_port,
                           bytes_sent: bytes_sent,
                           bytes_received: bytes_received,
                           duration: fin_pkt.timestamp - syn_pkt.timestamp,
                           mac_address: fin_pkt.mac_address,
                           device: d,
                           timestamp: syn_pkt.timestamp

        fin_pkt.update_attributes(flow: flow)
        syn_pkt.update_attributes(flow: flow)
        dst_syn_pkt.update_attributes(flow: flow)
      end
    end
  end

  def self.mark_flows
    PartialFlow.where(is_fin: true).each do |fin_pkt|
      next unless self.is_local?(fin_pkt.dst_ip)

      syn_pkt = self.find_syn_pkt fin_pkt
      next unless syn_pkt
        
      dst_syn_pkt = self.find_dst_syn_pkt fin_pkt
      next unless dst_syn_pkt

      next if self.is_already_processed? syn_pkt

      flow = Flow.find src_ip: syn_pkt.src_ip,
                       dst_ip: syn_pkt.dst_ip,
                       src_port: syn_pkt.src_port,
                       dst_port: syn_pkt.dst_port

      fin_pkt.update_attributes(flow: flow)
      syn_pkt.update_attributes(flow: flow)
      dst_syn_pkt.update_attributes(flow: flow)
    end
  end

  protected
  def self.is_local?(ip)
    ip.to_s.match /^10\./
  end

  def self.is_already_processed?(syn_pkt)
    ! Flow.where(src_ip: syn_pkt.src_ip,
                 dst_ip: syn_pkt.dst_ip,
                 src_port: syn_pkt.src_port,
                 dst_port: syn_pkt.dst_port,
                 ).first.nil?
#               ).where("timestamp > ? AND timestamp < ?", syn_pkt.timestamp - 10.seconds, syn_pkt.timestamp + 10.seconds).first.nil?
  end

  def self.find_syn_pkt(fin_pkt)
     PartialFlow.where(is_syn: true,
                       src_ip: fin_pkt.dst_ip,
                       dst_ip: fin_pkt.src_ip,
                       src_port: fin_pkt.dst_port,
                       dst_port: fin_pkt.src_port
                       ).where("timestamp <= ?", fin_pkt.timestamp).first
  end

  def self.find_dst_syn_pkt(fin_pkt)
     PartialFlow.where(is_syn: true,
                       src_ip: fin_pkt.src_ip,
                       dst_ip: fin_pkt.dst_ip,
                       src_port: fin_pkt.src_port,
                       dst_port: fin_pkt.dst_port
                       ).first
#                       ).where("timestamp <= ?", fin_pkt.timestamp).first
  end
end
