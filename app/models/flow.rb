class Flow < ApplicationRecord
  belongs_to :device

  def self.identify
    ActiveRecord::Base.logger.silence do
      puts "Got so many", PartialFlow.where(is_fin: true).count

      PartialFlow.where(is_fin: true).each do |pflow|
        # only consider fin from the remote host
        unless self.is_local?(pflow.dst_ip)
          next
        end

        possibles = PartialFlow.where(is_syn: true,
                                      src_ip: pflow.dst_ip,
                                      dst_ip: pflow.src_ip,
                                      src_port: pflow.dst_port,
                                      dst_port: pflow.src_port
                                     ).where("timestamp <= ?", pflow.timestamp)

        if possibles.all.count > 1
          puts 'TOO MANY DICKS ON THE DANCE FLOOR'
          pp pflow
          puts '>> MATCHES'
          pp possibles.all
        end

        match = possibles.first
        next unless match

        d = Device.where("? = ANY(ipv4)", match.src_ip.to_s).first || Device.where("? = ANY(ipv4)", match.dst_ip.to_s).first
        unless d
          d = Device.create mac_address: pflow.mac_address,
                            ipv4: [ match.src_ip ],
                            kind: '',
                            last_seen: Time.now
        end

        local_fin = PartialFlow.where(is_fin: true,
                                      src_ip: pflow.dst_ip,
                                      dst_ip: pflow.src_ip,
                                      src_port: pflow.dst_port,
                                      dst_port: pflow.src_port
                                     ).where("timestamp <= ?", pflow.timestamp).first
        remote_syn =  PartialFlow.where(is_syn: true,
                                        src_ip: pflow.src_ip,
                                        dst_ip: pflow.dst_ip,
                                        src_port: pflow.dst_port,
                                        dst_port: pflow.src_port
                                       ).where("timestamp <= ?", pflow.timestamp).first


        if local_fin && remote_syn
          bytes_received = local_fin.src_ack - remote_syn.src_seq - 2
        else
          bytes_received = 0
        end

          # we sub 2 from the bytes sent to account for SYN and FIN
        Flow.create src_ip: match.src_ip,
                    dst_ip: match.dst_ip,
                    src_port: match.src_port,
                    dst_port: match.dst_port,
                    bytes_sent: pflow.src_ack - match.src_seq - 2,
                    bytes_received: bytes_received,
                    duration: pflow.timestamp - match.timestamp,
                    mac_address: pflow.mac_address,
                    device: d
      end
    end
  end

  protected
  def self.is_local?(ip)
    ip.to_s.match /^10\./
  end
end
