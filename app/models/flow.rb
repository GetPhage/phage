class Flow < ApplicationRecord
  belongs_to :device

  def self.identify
    ActiveRecord::Base.logger = nil
    puts "Got so many", PartialFlow.where(is_fin: true).count

    PartialFlow.where(is_fin: true).each do |pflow|
      possibles = PartialFlow.where(is_syn: true,
                                    src_port: pflow.dst_port,
                                    dst_port: pflow.src_port
                                   )

      if possibles.all.count > 1
        puts 'TOO MANY DICKS'
        pp pflow
        puts '>> MATCHES'
        pp possibles.all
      end

      if possibles.all.count == 1
        match = possibles.first
        Flow.create src_ip: match.src_ip,
                    dst_ip: match.dst_ip,
                    src_port: match.src_port,
                    dst_port: match.dst_port,
                    bytes_sent: pflow.src_ack - match.src_seq,
                    duration: pflow.timestamp - match.timestamp,
                    mac_address: pflow.mac_address
      end
    end
  end
end
