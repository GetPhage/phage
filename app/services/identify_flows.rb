class IdentifyFlows
  def initialize(syn_pkt)
    @syn_packets = Array.new
    @syn_ack_packets = Array.new
    @fin_packets = Array.new
    @fin_ack_packets = Array.new
    @rst_packets = Array.new

    @syn_packets.push syn_pkt

    @flow = nil
    @device = nil
  end

  def work
    discover_packets

    categorize_packets

    return unless has_syn_ack? && ( has_initial_fin? || has_reset? )

    find_device

    create_flow

    mark_flow
  end

  def discover_packets
    syn_pkt = @syn_packets.first

    @packets = PartialFlow.where(src_ip: syn_pkt.src_ip,
                                 dst_ip: syn_pkt.dst_ip,
                                 src_port: syn_pkt.src_port,
                                 dst_port: syn_pkt.dst_port,
                                 state: :unmatched)
                 .or(
                   PartialFlow.where(src_ip: syn_pkt.dst_ip,
                                     dst_ip: syn_pkt.src_ip,
                                     src_port: syn_pkt.dst_port,
                                     dst_port: syn_pkt.src_port,
                                     state: :unmatched)
                 )
                 .order(timestamp: :asc)
  end

  def categorize_packets
    @packets.order(timestamp: :asc, id: :asc).each do |pkt|
      if too_old?(pkt) then
#        puts '>>>>>>> TOO FUCKING OLD <<<<<<<<'
#        pp pkt
        return
      end

      if pkt.is_rst?
        if is_retransmit?(pkt, @rst_packets) || !has_reset?
          @rst_packets.push pkt
        end

        next
      end

      if pkt.is_syn?
        if is_retransmit?(pkt, @syn_packets)
          @syn_packets.push pkt
        elsif is_retransmit?(pkt, @syn_ack_packets) || syn_matches?(pkt, @syn_packets.first)
          @syn_ack_packets.push pkt
        end

        next
      end

      if pkt.is_fin?
        if is_retransmit?(pkt, @fin_packets)
          @fin_packets.push pkt
        elsif is_retransmit?(pkt, @fin_ack_packets)
          @fin_ack_packets.push pkt
        elsif pkt.src_ip == @syn_packets.first.src_ip
          @fin_packets.push pkt
        else
          @fin_ack_packets.push pkt
        end

        next
      end

    end
  end


  def create_flow
    syn_pkt = @syn_packets.first
    syn_ack_pkt = @syn_ack_packets.first
    fin_pkt = @fin_packets.first

if false
    puts ">>> SYN"
    pp @syn_packets

    puts ">>> SYN ACK"
    pp @syn_ack_packets

    puts ">>> FIN"
    pp @fin_packets

    puts ">>> FIN ACK"
    pp @fin_ack_packets

    puts ">>> RST"
    pp @rst_packets
end

    unless @device
      @device = Device.create mac_address: fin_pkt.mac_address,
                              ipv4: [ syn_pkt.src_ip ],
                              kind: '',
                              last_seen: Time.now
    end

    bytes_sent = 0
    bytes_received = 0

    if has_reset?
      state = :reset
      duration = (@rst_packets.first.timestamp - syn_pkt.timestamp).abs
    elsif !has_syn_ack? || !has_initial_fin? || !has_fin_ack?
      state = :incomplete
      duration = 0
    else
      bytes_sent = fin_pkt.src_seq - syn_pkt.src_seq - 1
      bytes_received = fin_pkt.src_ack - syn_ack_pkt.src_seq - 2
      duration = fin_pkt.timestamp - syn_pkt.timestamp
      state = :complete
    end

    @flow = Flow.create src_ip: syn_pkt.src_ip,
                        dst_ip: syn_pkt.dst_ip,
                        src_port: syn_pkt.src_port,
                        dst_port: syn_pkt.dst_port,
                        bytes_sent: bytes_sent,
                        bytes_received: bytes_received,
                        duration: duration,
                        mac_address: syn_pkt.mac_address,
                        device: @device,
                        state: state,
                        timestamp: syn_pkt.timestamp
  end

  def mark_flow
    @syn_packets.each do |pkt| pkt.update_attributes(flow: @flow, state: :matched, device: @device) end
    @syn_ack_packets.each do |pkt| pkt.update_attributes(flow: @flow, state: :matched, device: @device) end
    @fin_packets.each do |pkt| pkt.update_attributes(flow: @flow, state: :matched, device: @device) end
    @fin_ack_packets.each do |pkt| pkt.update_attributes(flow: @flow, state: :matched, device: @device) end
    @rst_packets.each do |pkt| pkt.update_attributes(flow: @flow, state: :matched, device: @device) end
  end

  
  def syn_matches?(pkt, possible_match)
    pkt.src_ack == possible_match.src_seq + 1
  end
  
  def fin_matches?(pkt, possible_match)
    pkt.src_ack == possible_match.src_seq + 1
  end

  def is_retransmit?(pkt, list)
    first = list.first
    return false unless first

    pkt.src_seq == first.src_seq &&
      pkt.src_ack == first.src_ack &&
      pkt.is_syn? == first.is_syn? &&
      pkt.is_fin? == first.is_fin? &&
      pkt.is_rst? == first.is_rst?
  end

  def find_device
    pkt = @syn_packets.first
    @device = Device.where("? = ANY(ipv4)", pkt.src_ip.to_s).first || Device.where("? = ANY(ipv4)", pkt.dst_ip.to_s).first
  end

  def has_syn_ack?
    !@syn_ack_packets.empty?
  end

  def has_initial_fin?
    !@fin_packets.empty?
  end

  def has_fin_ack?
    !@fin_ack_packets.empty?
  end

  def has_reset?
    !@rst_packets.empty?
  end

  def too_old?(pkt)
    ages = Array.new
    ages.push @syn_packets.max_by { |pkt| pkt.timestamp }
    ages.push @syn_ack_packets.max_by { |pkt| pkt.timestamp }
    ages.push @fin_packets.max_by { |pkt| pkt.timestamp }
    ages.push @fin_ack_packets.max_by { |pkt| pkt.timestamp }
    ages.push @rst_packets.max_by { |pkt| pkt.timestamp }

    most_recent = ages.max_by { |pkt| if pkt then pkt.timestamp else Time.at(0).to_datetime end }

#    pp pkt.timestamp, most_recent.timestamp, most_recent.timestamp + 30.minutes
    pkt.timestamp > most_recent.timestamp + 30.minutes
  end

end
