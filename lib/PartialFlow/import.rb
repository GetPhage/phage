require 'pcap'
require 'pp'

class PartialFlow
  def self.import(file)
    pcap = Pcap::Capture.open_offline(file)

    pcap.each_packet do |pkt|
      next unless pkt.tcp?

      PartialFlow.create  src_ip: pkt.src.to_s,
                          dst_ip: pkt.dst.to_s,
                          src_port: pkt.sport,
                          dst_port: pkt.dport,
                          src_seq: pkt.tcp_seq,
                          src_ack: pkt.tcp_ack,
                          src_syn: pkt.tcp_syn?,
                          src_fin: pkt.tcp_fin?,
                          src_rst: pkt.tcp_rst?,
                          mac_address: pkt.mac_address,
                          timestamp: pkt.time_i
    end
  end
end
