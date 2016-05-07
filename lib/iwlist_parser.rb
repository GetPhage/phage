#!/usr/bin/ruby
# coding: utf-8

# from https://gist.github.com/mqu/5257627
# author : Marc Quinton, march 2013, licence : http://fr.wikipedia.org/wiki/WTFPL

=begin

  Cell 52 - Address: 00:24:D4:51:53:20
			ESSID:"Freebox-A7D027"
			Mode:Master
			Frequency:2.427 GHz (Channel 4)
			Quality=9/70  Signal level=-86 dBm  Noise level=-95 dBm
			Encryption key:on
			Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
					  9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
					  48 Mb/s; 54 Mb/s
			Extra:bcn_int=96

WPA1
		IE: WPA Version 1
			Group Cipher : CCMP
			Pairwise Ciphers (1) : CCMP
			Authentication Suites (1) : PSK
		Extra:wme_ie=dd180050f2020101000403a4000027a4000042435e0062322f00

WPA2
		IE: IEEE 802.11i/WPA2 Version 1
		Group Cipher : CCMP
		Pairwise Ciphers (1) : CCMP
		Authentication Suites (1) : PSK    

    
=end

class IwlistCell
  attr_reader :ssid, :address, :mode, :encryption
  def initialize lines
    @values={}
    # @lines = lines.split("\n")
    lines.split("\n").each do |s|
      if m=s.match(/ESSID:"(.*)"/)
	@values[:ssid] = m[1]
      elsif m=s.match(/Mode:(.*)/)
	@values[:mode] = m[1]
      elsif m=s.match(/Frequency:(.*?) \(Channel (\d+)\)/)
	@values[:frequency] = m[1] ; @values[:channel]=m[2].to_i
      elsif m=s.match(/Address: (.*)/)
	@values[:address] = m[1]
      elsif m=s.match(/Encryption key:(.*)/)
	@values[:encryption] = m[1]
	if @values[:encryption] == 'on'
	  @values[:wpa] = 'wep'
	else
	  @values[:wpa] = '-'
	end
      elsif m=s.match(/WPA Version (.*)/)
	@values[:wpa] = 'wpa1'
      elsif m=s.match(/WPA2/)
	@values[:wpa] = 'wpa2'
      # Quality=9/70  Signal level=-86 dBm  Noise level=-95 dBm
      elsif m=s.match(/Quality=(.*?) .*Signal level=-*(\d+) dBm  Noise level=(.*) dBm/)
	@values[:quality] = self.quality_to_percent(m[1])
	@values[:level] = m[2]
	@values[:noise] = m[3]
      end

    end
  end
  def quality_to_percent(q)
    n = q.split("/").map(&:to_i)
    return (n[0] * 100) / n[1]
  end
end

class IwlistScanParser
  def parse content
    cells = []
    content.split(/Cell /m).each do |txt|
      cells << IwlistCell.new(txt)
    end
    
    return cells
  end
end
