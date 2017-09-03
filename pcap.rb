#!/usr/bin/env ruby

require 'pcap'
require 'pp'

packets = []

flows = []

ARGV.each do |file|
  pp packets

  pcap = Pcap::Capture.open_offline(file)

  pcap.each_packet do |pkt|
    next unless pkt.tcp?

    if pkt.tcp_syn?
      packets.push({
        syn: true,
        src_ip: pkt.src.to_s,
        dst_ip: pkt.dst.to_s,
        src_port: pkt.sport,
        dst_port: pkt.dport,
        seq: pkt.tcp_seq
      })
      next
    end

    if pkt.tcp_fin?
      
    end
  end

end
