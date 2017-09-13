class Flow < ApplicationRecord
  belongs_to :device

  def self.identify
    ActiveRecord::Base.logger.silence do
      puts "Got so many", PartialFlow.where(is_fin: true).count

      PartialFlow.where(is_fin: true).each do |pflow|
        possibles = PartialFlow.where(is_syn: true,
                                      src_port: pflow.dst_port,
                                      dst_port: pflow.src_port
                                     ).where("timestamp <= ?", pflow.timestamp)

        if possibles.all.count > 1
          puts 'TOO MANY DICKS ON THE DANCE FLOOR'
          pp pflow
          puts '>> MATCHES'
          pp possibles.all
        end

        if possibles.all.count == 1
          match = possibles.first

          # we sub 2 from the bytes sent to account for SYN and FIN
          Flow.create src_ip: match.src_ip,
                      dst_ip: match.dst_ip,
                      src_port: match.src_port,
                      dst_port: match.dst_port,
                      bytes_sent: pflow.src_ack - match.src_seq - 2,
                      duration: pflow.timestamp - match.timestamp,
                      mac_address: pflow.mac_address
        end
      end
    end
  end
end
