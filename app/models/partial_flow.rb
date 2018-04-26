require 'pp'

class PartialFlow < ApplicationRecord
  belongs_to :device
  belongs_to :flow, optional: true

  enum state: [ :unmatched, :matched, :ignored, :syn1, :syn2, :rst, :duplicate, :fin1, :fin2 ]

  def self.import(data)
    ActiveRecord::Base.logger.silence do
      packets = JSON.parse(data, symbolize_names: true)
      packets.each do |pkt|
        PartialFlow.create  src_ip: pkt[:src_ip],
                                     dst_ip: pkt[:dst_ip],
                                     src_port: pkt[:src_port],
                                     dst_port: pkt[:dst_port],
                                     src_seq: pkt[:seq],
                                     src_ack: pkt[:ack],
                                     is_syn: pkt[:syn],
                                     is_fin: pkt[:fin],
                                     is_rst: pkt[:rst],
                                     mac_address: pkt[:ether_src],
                                     timestamp: Time.at(pkt[:time]).to_datetime,
                                     state: :unmatched
      end
    end
  end
end
