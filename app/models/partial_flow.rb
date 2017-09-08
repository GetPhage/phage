require 'pp'

class PartialFlow < ApplicationRecord
  belongs_to :device

  def self.import(file)

    packets = JSON.parse(File.read(file), symbolize_names: true)
    packets.each do |pkt|
      pp pkt

      PartialFlow.create  src_ip: pkt[:src_ip],
                          dst_ip: pkt[:dst_ip],
                          src_port: pkt[:src_port],
                          dst_port: pkt[:dst_port],
                          src_seq: pkt[:seq],
                          src_ack: pkt[:ack],
                          is_syn: pkt[:syn],
                          is_fin: pkt[:fin],
                          is_rst: pkt[:rst],
                          mac_address: '01:02:03:04:05:06',
                          timestamp: Time.at(pkt[:time]).to_datetime
    end

  end
end
