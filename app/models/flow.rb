class Flow < ApplicationRecord
  belongs_to :device

  enum state: [ :complete, :reset, :incomplete ]

  def country
    puts dst_ip.to_s
    geo_ip = GeoIp.where("ipaddr >>= inet ?", dst_ip.to_s).first
    geo_ip.try(:geo_location)
  end


  def self.identify(max_work = 0)
    ActiveRecord::Base.logger.silence do
      puts "Got so many", PartialFlow.where(is_syn: true, state: :unmatched).count
      
      processed = 0
      PartialFlow.where(is_syn: true, src_ack: 0, state: :unmatched).order(id: :asc).find_each do |syn_pkt|
        identifier = IdentifyFlows.new syn_pkt
        identifier.work

        if max_work > 0 && processed > max_work
          return
        end

        processed +=1 
      end
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
